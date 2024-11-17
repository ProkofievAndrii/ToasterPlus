//
//  KeyboardManager.swift
//  Toaster
//
//  Created by Andrii Prokofiev on 16.11.2024.
//

import UIKit

/// Manager for monitoring keyboard state and height changes.
class KeyboardManager {
    // MARK: - Singleton Instance

    /// Shared instance of `KeyboardManager`.
    static let shared = KeyboardManager()

    // MARK: - Properties

    /// Current height of the keyboard. Defaults to `0`.
    private var keyboardHeight: CGFloat = 0

    // MARK: - Initialization

    private init() {
        subscribeToKeyboardNotifications()
    }

    // MARK: - Notifications Subscription

    /// Subscribes to keyboard-related notifications.
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Notification Handlers

    /// Handles the keyboard "will show" event.
    ///
    /// - Parameter notification: The notification containing keyboard information.
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = frame.height
        notifyKeyboardHeightChanged()
    }

    /// Handles the keyboard "will hide" event.
    ///
    /// - Parameter notification: The notification containing keyboard information.
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardHeight = 0
        notifyKeyboardHeightChanged()
    }

    // MARK: - Public Methods

    /// Retrieves the current height of the keyboard.
    ///
    /// - Returns: The current height of the keyboard as a `CGFloat`.
    func currentKeyboardHeight() -> CGFloat {
        return keyboardHeight
    }

    // MARK: - Internal Notifications

    /// Posts a notification when the keyboard height changes.
    private func notifyKeyboardHeightChanged() {
        NotificationCenter.default.post(
            name: .keyboardHeightChanged,
            object: nil,
            userInfo: ["height": keyboardHeight]
        )
    }
}

// MARK: - Notification Name Extension

extension Notification.Name {
    /// Notification for keyboard height changes.
    static let keyboardHeightChanged = Notification.Name("keyboardHeightChanged")
}
