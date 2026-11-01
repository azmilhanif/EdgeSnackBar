//
//  EdgeSnackBar+Appearance.swift
//  EdgeSnackBar
//
//  Created by Azmil Hanif on 1/11/26.
//  Copyright © 2026 Threeg Media. All rights reserved.
//


#if canImport(UIKit)
import UIKit

@available(iOSApplicationExtension, unavailable)
extension EdgeSnackBar {

    public struct Appearance {
        public var successColor: UIColor
        public var errorColor: UIColor
        public var warningColor: UIColor
        public var neutralBackground: UIColor
        public var neutralForeground: UIColor
        public var filledForeground: UIColor
        public var accentColor: UIColor
        public var messageFont: UIFont
        public var actionFont: UIFont
        public var cornerRadius: CGFloat
        public var shadowOpacity: Float

        public init(successColor: UIColor = UIColor(red: 0.26, green: 0.63, blue: 0.28, alpha: 1),
                    errorColor: UIColor = UIColor(red: 0.78, green: 0.16, blue: 0.16, alpha: 1),
                    warningColor: UIColor = UIColor(red: 0.90, green: 0.32, blue: 0.0, alpha: 1),
                    neutralBackground: UIColor = UIColor { $0.userInterfaceStyle == .dark
                        ? UIColor(white: 0.92, alpha: 1)
                        : UIColor(white: 0.2, alpha: 1) },
                    neutralForeground: UIColor = UIColor { $0.userInterfaceStyle == .dark ? .black : .white },
                    filledForeground: UIColor = .white,
                    accentColor: UIColor = .systemBlue,
                    messageFont: UIFont = .systemFont(ofSize: 15, weight: .medium),
                    actionFont: UIFont = .systemFont(ofSize: 14, weight: .bold),
                    cornerRadius: CGFloat = 0,
                    shadowOpacity: Float = 0.25) {
            self.successColor = successColor
            self.errorColor = errorColor
            self.warningColor = warningColor
            self.neutralBackground = neutralBackground
            self.neutralForeground = neutralForeground
            self.filledForeground = filledForeground
            self.accentColor = accentColor
            self.messageFont = messageFont
            self.actionFont = actionFont
            self.cornerRadius = cornerRadius
            self.shadowOpacity = shadowOpacity
        }

        public static var `default`: Appearance { Appearance() }
    }
}
#endif
