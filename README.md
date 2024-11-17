# ToasterPlus

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

ToasterPlus is a lightweight, customizable, and feature-rich Swift framework for displaying toast notifications in iOS applications. It supports various features like keyboard awareness, accessibility (VoiceOver), and multiple positioning options.

---

## 📋 Features

- **Toast Notifications**: Show simple, non-intrusive toast notifications anywhere in your app.
- **Customizable**: Adjust colors, fonts, shadows, and more using `ToastAppearance`.
- **Positioning**: Display toasts at the top, middle, or bottom of the screen with support for different alignments (e.g., left, center, right).
- **Keyboard Awareness**: Automatically adjusts toast position when the keyboard is shown or hidden.
- **Accessibility**: Supports VoiceOver for announcing toast messages.
- **Predefined Styles**: Use success, error, or warning presets out of the box.
- **Queueing**: Automatically queues multiple toasts for sequential display.

---

## 📦 Installation

### Swift Package Manager (SPM)

1. In Xcode, go to `File` → `Add Packages`.
2. Enter the repository URL: `https://github.com/ProkofievAndrii/ToasterPlus.git`.
3. Select the desired version and click "Add Package".

### CocoaPods

Add the following line to your `Podfile`:

```ruby 
pod 'ToasterPlus'
```

Then run:

```bash 
pod install
```

## 🔧 Usage

### Showing a Simple Toast

To display a basic toast notification:

```swift
Toast(message: "Hello, Toaster!")
```

### Queue Management

### Cancel a Specific Toast

You can save a Toast instance to a variable and cancel it if needed:

```swift
let toast = Toast(message: "Cancelable Toast")
toast.cancel()
```

To cancel the currently displayed toast:

```swift
ToastCenter.default.cancelCurrentToast()
```

To clear the entire toast queue:

```swift
ToastCenter.default.cancelAll()
```

### Advanced Usage

### Display Toast with Attributed Text

To show a toast with custom styles using NSAttributedString:

```swift
let attributedText = NSAttributedString(
    string: "Attributed Toast",
    attributes: [
        .foregroundColor: UIColor.red,
        .backgroundColor: UIColor.yellow,
        .font: UIFont.boldSystemFont(ofSize: 18),
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
)

Toast(attributedMessage: attributedText, position: .bottomCenter)
```

### Customize Appearance

```swift
var appearance = ToastAppearance()
appearance.backgroundColor = .systemBlue
appearance.textColor = .white
appearance.cornerRadius = 8
appearance.font = .boldSystemFont(ofSize: 16)

Toast(message: "Custom Toast", appearance: appearance)
```

### Predefined Styles

```swift
Toast.success(message: "Operation completed successfully!")
Toast.error(message: "Something went wrong!")
Toast.warning(message: "This is a warning!")
```

### Positioning

9 possible positions available

```swift
Toast(message: "Top Right Toast", position: .topRight)
Toast(message: "Middle Center Toast", position: .middleCenter)
Toast(message: "Bottom Left Toast", position: .bottomLeft)
```

### Keyboard Awareness

Toasts automatically reposition themselves above the keyboard when it is shown. No additional configuration is needed.

### Accessibility Support

To enable VoiceOver announcements for toasts:

```swift
ToastCenter.default.isSupportAccessibility = true
```

## ⚙️ Requirements

iOS 13.0+
Swift 5.0+

## 📜 License
ToasterPlus is available under the MIT License.
