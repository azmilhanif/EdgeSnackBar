// The Swift Programming Language
// https://docs.swift.org/swift-book


#if canImport(UIKit)
import UIKit
import os

@available(iOSApplicationExtension, unavailable)
public final class EdgeSnackBar: NSObject {

    public static let shared = EdgeSnackBar()

    public var appearance: Appearance = .default
    public var windowProvider: (() -> UIWindow?)?

    private var current: UIView?
    private var hideWork: DispatchWorkItem?

    public override init() {
        super.init()
    }

    private var window: UIWindow? {
        if let provider = windowProvider {
            return provider()
        }
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    public func show(_ message: String,
                     style: Style = .normal,
                     showsIcon: Bool? = nil,
                     icon: UIImage? = nil,
                     actionTitle: String? = nil,
                     duration: TimeInterval = 3,
                     action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(message,
                         style: style,
                         showsIcon: showsIcon,
                         icon: icon,
                         actionTitle: actionTitle,
                         duration: duration,
                         action: action)
        }
    }

    public func dismiss(animated: Bool = true) {
        if Thread.isMainThread {
            performDismiss(animated: animated)
        } else {
            DispatchQueue.main.async { self.performDismiss(animated: animated) }
        }
    }

    private func performDismiss(animated: Bool) {
        hideWork?.cancel()
        hideWork = nil
        guard let view = current else { return }
        current = nil
        let height = view.bounds.height
        UIView.animate(withDuration: animated ? 0.25 : 0, delay: 0, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: height)
        }, completion: { _ in
            view.removeFromSuperview()
        })
    }

    private func present(_ message: String,
                         style: Style,
                         showsIcon: Bool?,
                         icon: UIImage?,
                         actionTitle: String?,
                         duration: TimeInterval,
                         action: (() -> Void)?) {
        guard let window = window else {
            os_log("No key window, message dropped", log: .edgeSnackBar, type: .error)
            return
        }
        performDismiss(animated: false)

        let appearance = self.appearance
        let foreground = style.foreground(in: appearance)

        let container = UIView()
        container.backgroundColor = style.background(in: appearance)
        container.layer.cornerRadius = appearance.cornerRadius
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = appearance.shadowOpacity
        container.layer.shadowRadius = 12
        container.layer.shadowOffset = CGSize(width: 0, height: -2)
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = message
        label.textColor = foreground
        label.font = appearance.messageFont
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true

        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false

        let resolvedIcon: UIImage? = {
            guard showsIcon ?? appearance.showsIcons else { return nil }
            if let icon = icon { return icon }
            guard let name = style.iconName else { return nil }
            return UIImage(systemName: name)
        }()

        if let image = resolvedIcon {
            let iconView = UIImageView(image: image)
            iconView.tintColor = foreground
            iconView.contentMode = .scaleAspectFit
            iconView.setContentHuggingPriority(.required, for: .horizontal)
            iconView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 22).isActive = true
            row.addArrangedSubview(iconView)
        }
        row.addArrangedSubview(label)

        if let actionTitle = actionTitle {
            let button = UIButton(type: .system)
            button.setTitle(actionTitle.uppercased(), for: .normal)
            button.titleLabel?.font = appearance.actionFont
            button.tintColor = style.actionColor(in: appearance)
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.addAction(UIAction { [weak self] _ in
                os_log("Action tapped", log: .edgeSnackBar, type: .debug)
                action?()
                self?.dismiss()
            }, for: .touchUpInside)
            row.addArrangedSubview(button)
        }

        container.addSubview(row)
        window.addSubview(container)
        let hasHomeIndicator = window.safeAreaInsets.bottom > 0
        let bottomPadding: CGFloat = hasHomeIndicator ? 4 : 22

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: -2),
            container.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 2),
            container.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 40),
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 22),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPadding)
        ])

        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        container.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))

        window.layoutIfNeeded()
        container.transform = CGAffineTransform(translationX: 0, y: container.bounds.height)
        current = container

        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            container.transform = .identity
        }

        UIAccessibility.post(notification: .announcement, argument: message)
        os_log("Shown: %{private}@", log: .edgeSnackBar, type: .debug, message)

        let work = DispatchWorkItem { [weak self, weak container] in
            guard let self = self, let container = container, self.current === container else { return }
            self.performDismiss(animated: true)
        }
        hideWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }

    @objc private func handleTap() {
        performDismiss(animated: true)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let y = max(gesture.translation(in: view).y, 0)
        switch gesture.state {
        case .changed:
            hideWork?.cancel()
            view.transform = CGAffineTransform(translationX: 0, y: y)
        case .ended, .cancelled:
            if y > 40 || gesture.velocity(in: view).y > 500 {
                performDismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25) { view.transform = .identity }
                let work = DispatchWorkItem { [weak self] in self?.performDismiss(animated: true) }
                hideWork = work
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: work)
            }
        default:
            break
        }
    }
}
#endif
