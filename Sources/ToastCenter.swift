//
//  ToastCenter.swift
//  Toaster
//

import UIKit

/// Manages the toast queue and handles their sequential display.
///
/// `ToastCenter` ensures that only one toast is displayed at a time
/// and manages the lifecycle of toast notifications, including canceling and resuming operations.
public final class ToastCenter {
    // MARK: - Public Properties

    /// The shared instance of `ToastCenter`.
    public static let `default` = ToastCenter()

    /// Determines if VoiceOver announcements are enabled for toasts.
    /// When enabled, the `accessibilityLabel` of each toast will be announced.
    @objc public var isSupportAccessibility: Bool = true

    // MARK: - Private Properties

    /// The operation queue that handles the sequential execution of toast operations.
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1 // Ensures operations run sequentially.
        queue.isSuspended = true // Queue starts in a suspended state until the app is ready.
        return queue
    }()

    /// Indicates whether the `ToastCenter` is ready to display toasts.
    private var isReady: Bool = false

    /// The currently displayed toast view, if any.
    private var currentToastView: ToastView?

    // MARK: - Initialization

    /// Private initializer to enforce singleton pattern.
    private init() {
        // Subscribe to notifications when the app becomes active.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppBecameActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    /// Deinitializes and removes observers.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public Methods

    /// Adds a new toast to the queue.
    ///
    /// - Parameter toast: The `Toast` instance to enqueue.
    public func add(_ toast: Toast) {
        queue.addOperation(toast)
    }

    /// Cancels and removes the currently displayed toast, if any.
    public func cancelCurrentToast() {
        guard let toastView = currentToastView else { return }
        toastView.removeFromSuperview()
        currentToastView = nil
    }

    /// Cancels all toasts in the queue and removes the currently displayed toast.
    public func cancelAll() {
        queue.cancelAllOperations()
        cancelCurrentToast()
    }

    /// Sets the currently displayed toast view.
    ///
    /// - Parameter toastView: The `ToastView` instance to set as the currently displayed toast.
    func setCurrentToastView(_ toastView: ToastView) {
        currentToastView = toastView
    }

    /// Clears the reference to the currently displayed toast view after its display ends.
    func clearCurrentToast() {
        currentToastView = nil
    }

    // MARK: - Private Methods

    /// Handles the event when the app becomes active and prepares the queue for execution.
    ///
    /// The queue starts executing only when the app is active, and an active window is available.
    @objc private func handleAppBecameActive() {
        guard !isReady else { return }
        if ToastView.getActiveWindow() != nil {
            isReady = true
            queue.isSuspended = false // Resumes the queue once the app is ready.
        }
    }
}
