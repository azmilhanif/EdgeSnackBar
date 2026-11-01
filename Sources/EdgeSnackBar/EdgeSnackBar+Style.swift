//
//  File.swift
//  EdgeSnackBar
//
//  Created by Azmil Hanif on 1/11/26.
//  Copyright © 2026 Threeg Media. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

@available(iOSApplicationExtension, unavailable)
extension EdgeSnackBar {

    public enum Style: CaseIterable {
        case normal, success, error, warning, info

        public var iconName: String? {
            switch self {
            case .normal: return nil
            case .success: return "checkmark.circle.fill"
            case .error: return "xmark.octagon.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }

        var isFilled: Bool {
            switch self {
            case .success, .error, .warning: return true
            case .normal, .info: return false
            }
        }

        func background(in appearance: Appearance) -> UIColor {
            switch self {
            case .success: return appearance.successColor
            case .error: return appearance.errorColor
            case .warning: return appearance.warningColor
            case .normal, .info: return appearance.neutralBackground
            }
        }

        func foreground(in appearance: Appearance) -> UIColor {
            isFilled ? appearance.filledForeground : appearance.neutralForeground
        }

        func actionColor(in appearance: Appearance) -> UIColor {
            isFilled ? appearance.filledForeground : appearance.accentColor
        }
    }
}
#endif
