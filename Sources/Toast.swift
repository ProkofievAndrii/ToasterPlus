//
//  Toast.swift
//  Toaster
//
//  Created by Andrii Prokofiev on 16.11.2024.
//

import UIKit

/// Represents a single toast notification that can be queued and displayed on screen.
public final class Toast: Operation {
    private let message: String?
    private let attributedMessage: NSAttributedString?
    private let appearance: ToastAppearance
    private let position: ToastPosition
    private let duration: TimeInterval
    private let delay: TimeInterval

    /// Initializes a new text-based toast.
    ///
    /// - Parameters:
    ///   - message: The plain text message to display.
    ///   - position: The position on the screen where the toast should appear. Default is `.bottomCenter`.
    ///   - duration: The duration the toast should remain on screen. Default is `.short`.
    ///   - delay: The delay before the toast appears. Default is `0`.
    ///   - appearance: The visual appearance settings for the toast. Default is `ToastAppearance.default`.
    @discardableResult
    public init(
        message: String,
        position: ToastPosition = ToastAppearance.default.defaultPosition,
        duration: TimeInterval = Delay.short,
        delay: TimeInterval = 0,
        appearance: ToastAppearance = .default
    ) {
        self.message = message
        self.attributedMessage = nil
        self.appearance = appearance
        self.position = position
        self.duration = duration
        self.delay = delay
        super.init()
        enqueue()
    }

    /// Initializes a new toast with an attributed string message.
    ///
    /// - Parameters:
    ///   - attributedMessage: The attributed string message to display.
    ///   - position: The position on the screen where the toast should appear. Default is `.bottomCenter`.
    ///   - duration: The duration the toast should remain on screen. Default is `.short`.
    ///   - delay: The delay before the toast appears. Default is `0`.
    ///   - appearance: The visual appearance settings for the toast. Default is `ToastAppearance.default`.
    @discardableResult
    public init(
        attributedMessage: NSAttributedString,
        position: ToastPosition = ToastAppearance.default.defaultPosition,
        duration: TimeInterval = Delay.short,
        delay: TimeInterval = 0,
        appearance: ToastAppearance = .default
    ) {
        self.message = nil
        self.attributedMessage = attributedMessage
        self.appearance = appearance
        self.position = position
        self.duration = duration
        self.delay = delay
        super.init()
        enqueue()
    }

    /// Predefined toast for success messages.
    ///
    /// - Parameters:
    ///   - message: The plain text success message to display.
    ///   - position: The position on the screen where the toast should appear. Default is `.bottomCenter`.
    ///   - duration: The duration the toast should remain on screen. Default is `.short`.
    ///   - delay: The delay before the toast appears. Default is `0`.
    /// - Returns: A `Toast` instance with pre-configured success appearance.
    @discardableResult
    public static func success(
        message: String,
        position: ToastPosition = .bottomCenter,
        duration: TimeInterval = Delay.short,
        delay: TimeInterval = 0
    ) -> Toast {
        let appearance = ToastAppearance.successPreset()
        return Toast(message: message, position: position, duration: duration, delay: delay, appearance: appearance)
    }

    /// Predefined toast for error messages.
    ///
    /// - Parameters:
    ///   - message: The plain text error message to display.
    ///   - position: The position on the screen where the toast should appear. Default is `.bottomCenter`.
    ///   - duration: The duration the toast should remain on screen. Default is `.short`.
    ///   - delay: The delay before the toast appears. Default is `0`.
    /// - Returns: A `Toast` instance with pre-configured error appearance.
    @discardableResult
    public static func error(
        message: String,
        position: ToastPosition = .bottomCenter,
        duration: TimeInterval = Delay.short,
        delay: TimeInterval = 0
    ) -> Toast {
        let appearance = ToastAppearance.errorPreset()
        return Toast(message: message, position: position, duration: duration, delay: delay, appearance: appearance)
    }

    /// Predefined toast for warning messages.
    ///
    /// - Parameters:
    ///   - message: The plain text warning message to display.
    ///   - position: The position on the screen where the toast should appear. Default is `.bottomCenter`.
    ///   - duration: The duration the toast should remain on screen. Default is `.short`.
    ///   - delay: The delay before the toast appears. Default is `0`.
    /// - Returns: A `Toast` instance with pre-configured warning appearance.
    @discardableResult
    public static func warning(
        message: String,
        position: ToastPosition = .bottomCenter,
        duration: TimeInterval = Delay.short,
        delay: TimeInterval = 0
    ) -> Toast {
        let appearance = ToastAppearance.warningPreset()
        return Toast(message: message, position: position, duration: duration, delay: delay, appearance: appearance)
    }

    /// The main method for executing the toast operation.
    ///
    /// Displays the toast and waits for the duration before allowing the next toast in the queue to execute.
    public override func main() {
        guard !isCancelled else { return }

        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            guard !self.isCancelled else {
                semaphore.signal()
                return
            }

            DispatchQueue.main.async {
                guard let window = ToastView.getActiveWindow() else {
                    semaphore.signal()
                    return
                }

                let toastView = ToastView(
                    message: self.message,
                    attributedMessage: self.attributedMessage,
                    appearance: self.appearance,
                    position: self.position
                )

                ToastCenter.default.setCurrentToastView(toastView)

                window.addSubview(toastView)
                toastView.show(duration: self.duration) {
                    ToastCenter.default.clearCurrentToast()
                    semaphore.signal()
                }
            }
        }

        semaphore.wait()
    }

    /// Adds the toast to the display queue.
    private func enqueue() {
        ToastCenter.default.add(self)
    }
}
