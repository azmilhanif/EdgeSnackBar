# EdgeSnackBar

A lightweight, edge-to-edge snack bar for UIKit. It slides up from the bottom and supports swipe-to-dismiss, tap-to-dismiss, an optional action button, and VoiceOver announcements.

## Requirements
- iOS 14+
- Swift 5.9+

## Installation

In Xcode, go to **File → Add Package Dependencies…** and enter:

```
https://github.com/azmilhanig/EdgeSnackBar.git
```

Or in `Package.swift`:

```swift
.package(url: "https://github.com/azmilhanig/EdgeSnackBar.git", from: "1.0.0")
```

## Usage

```swift
import EdgeSnackBar

EdgeSnackBar.shared.show("Saved")
EdgeSnackBar.shared.show("Order accepted", style: .success)
EdgeSnackBar.shared.show("Connection lost", style: .error, actionTitle: "Retry") {
    reload()
}
EdgeSnackBar.shared.dismiss()
```

Styles: `.normal`, `.success`, `.error`, `.warning`, `.info`

## Customisation

```swift
EdgeSnackBar.shared.appearance.accentColor = .systemIndigo
EdgeSnackBar.shared.appearance.cornerRadius = 16
EdgeSnackBar.shared.appearance.showsIcons = false
EdgeSnackBar.shared.show("Saved", style: .success, showsIcon: false)
EdgeSnackBar.shared.show("New order", style: .info, icon: UIImage(systemName: "bag.fill"))
EdgeSnackBar.shared.windowProvider = { myWindow }
```

## License
MIT
