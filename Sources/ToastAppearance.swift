//
//  ToastAppearance.swift
//  Toaster
//
//  Created by Andrii Prokofiev on 16.11.2024.
//

import UIKit

/// Defines the visual appearance of toast notifications.
///
/// Use this structure to customize the default styling of toasts or create specific presets for different scenarios, such as success, error, or warning.
public struct ToastAppearance {
    // MARK: - Static Properties

    /// The default appearance used by toasts if no custom appearance is specified.
    public static var `default` = ToastAppearance()

    // MARK: - Properties

    /// The default position of the toast on the screen.
    public var defaultPosition: ToastPosition = .bottomCenter

    /// The background color of the toast.
    public var backgroundColor: UIColor = .black.withAlphaComponent(0.8)

    /// The text color of the toast's message.
    public var textColor: UIColor = .white

    /// The font used for the toast's message.
    public var font: UIFont = .systemFont(ofSize: 14)

    /// The corner radius for rounding the toast's edges.
    public var cornerRadius: CGFloat = 10

    /// The padding around the text inside the toast.
    public var textInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    /// The color of the shadow around the toast.
    public var shadowColor: UIColor = .black

    /// The opacity of the shadow. Ranges from `0.0` (transparent) to `1.0` (opaque).
    public var shadowOpacity: Float = 0.3

    /// The blur radius of the shadow.
    public var shadowRadius: CGFloat = 4

    /// The offset of the shadow relative to the toast's position.
    public var shadowOffset: CGSize = CGSize(width: 0, height: 2)

    // MARK: - Preset Methods

    /// Initializes a custom `ToastAppearance` for targeted Toasts.
      public init() {}
    
    /// Returns a `ToastAppearance` preset for success messages.
    ///
    /// - Returns: A `ToastAppearance` with a green background and bold white text.
    public static func successPreset() -> ToastAppearance {
        var appearance = ToastAppearance()
        appearance.backgroundColor = .systemGreen
        appearance.textColor = .white
        appearance.font = .boldSystemFont(ofSize: 16)
        return appearance
    }

    /// Returns a `ToastAppearance` preset for error messages.
    ///
    /// - Returns: A `ToastAppearance` with a red background and bold white text.
    public static func errorPreset() -> ToastAppearance {
        var appearance = ToastAppearance()
        appearance.backgroundColor = .systemRed
        appearance.textColor = .white
        appearance.font = .boldSystemFont(ofSize: 16)
        return appearance
    }

    /// Returns a `ToastAppearance` preset for warning messages.
    ///
    /// - Returns: A `ToastAppearance` with a yellow background and bold black text.
    public static func warningPreset() -> ToastAppearance {
        var appearance = ToastAppearance()
        appearance.backgroundColor = .systemYellow
        appearance.textColor = .black
        appearance.font = .boldSystemFont(ofSize: 16)
        return appearance
    }
}
