//
//  ToastView.swift
//  Toaster
//
//  Created by Andrii Prokofiev on 16.11.2024.
//

import UIKit

/// Visual component responsible for rendering and displaying a Toast notification.
public final class ToastView: UIView {
    // MARK: - Properties

    /// Label displaying the message content.
    private let label = UILabel()
    
    /// Position of the Toast on the screen.
    private let position: ToastPosition
    
    /// Constraints applied to the Toast for positioning.
    private var positionConstraints: [NSLayoutConstraint] = []

    // MARK: - Initializers

    /// Initializes a new `ToastView`.
    ///
    /// - Parameters:
    ///   - message: A plain text message to display.
    ///   - attributedMessage: A styled message to display.
    ///   - appearance: Visual appearance for the Toast.
    ///   - position: Position of the Toast on the screen.
    init(
        message: String? = nil,
        attributedMessage: NSAttributedString? = nil,
        appearance: ToastAppearance,
        position: ToastPosition,
        isInteractable: Bool = false
    ) {
        self.position = position
        super.init(frame: .zero)
        configure(with: message, attributedMessage: attributedMessage, appearance: appearance)
        setupView(with: appearance)
        configureAccessibility(with: message, attributedMessage: attributedMessage)
        subscribeToKeyboardNotifications()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Configuration Methods

    /// Configures the label text and its appearance.
    private func configure(with message: String?, attributedMessage: NSAttributedString?, appearance: ToastAppearance) {
        if let message = message {
            label.text = message
            label.textColor = appearance.textColor
            label.font = appearance.font
        } else if let attributedMessage = attributedMessage {
            label.attributedText = attributedMessage
        }
    }

    /// Configures the visual appearance of the Toast.
    private func setupView(with appearance: ToastAppearance) {
        backgroundColor = appearance.backgroundColor
        layer.cornerRadius = appearance.cornerRadius
        layer.shadowColor = appearance.shadowColor.cgColor
        layer.shadowOpacity = appearance.shadowOpacity
        layer.shadowRadius = appearance.shadowRadius
        layer.shadowOffset = appearance.shadowOffset

        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: appearance.textInsets.top),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.textInsets.left),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.textInsets.right),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.textInsets.bottom),
        ])
    }

    // MARK: - Accessibility

    /// Configures accessibility support for VoiceOver.
    private func configureAccessibility(with message: String?, attributedMessage: NSAttributedString?) {
        guard ToastCenter.default.isSupportAccessibility else { return }

        isAccessibilityElement = true
        accessibilityLabel = message ?? attributedMessage?.string
        accessibilityTraits = .staticText
    }

    // MARK: - Display Logic

    /// Displays the Toast on the screen.
    ///
    /// - Parameters:
    ///   - duration: The duration for which the Toast is visible.
    ///   - completion: Optional completion handler after the Toast is removed.
    func show(duration: TimeInterval, completion: (() -> Void)? = nil) {
        guard let window = Self.getActiveWindow() else {
            print("No active window found to display Toast.")
            return
        }

        window.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false

        positionConstraints = createInitialConstraints(in: window)
        NSLayoutConstraint.activate(positionConstraints)

        alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { _ in
            if ToastCenter.default.isSupportAccessibility, let label = self.accessibilityLabel {
                UIAccessibility.post(notification: .announcement, argument: label)
            }

            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
                completion?()
            }
        }
    }

    // MARK: - Constraints and Keyboard Adjustments

    /// Creates initial constraints based on the keyboard state.
    private func createInitialConstraints(in window: UIWindow) -> [NSLayoutConstraint] {
        let keyboardHeight = KeyboardManager.shared.currentKeyboardHeight()
        if keyboardHeight > 0, position.isBottomOrMiddle {
            return [
                bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -keyboardHeight - 20),
                centerXAnchor.constraint(equalTo: window.centerXAnchor)
            ]
        } else {
            return Self.constraints(for: self, in: window, position: position)
        }
    }

    /// Subscribes to keyboard notifications to adjust positioning dynamically.
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardHeightChanged(_:)),
            name: .keyboardHeightChanged,
            object: nil
        )
    }

    /// Handles changes in keyboard height and adjusts constraints accordingly.
    @objc private func handleKeyboardHeightChanged(_ notification: Notification) {
        guard position.isBottomOrMiddle, let superview = superview else { return }

        NSLayoutConstraint.deactivate(positionConstraints)

        let keyboardHeight = KeyboardManager.shared.currentKeyboardHeight()

        positionConstraints = keyboardHeight > 0 ?
            [
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -keyboardHeight - 20),
                centerXAnchor.constraint(equalTo: superview.centerXAnchor)
            ] :
            Self.constraints(for: self, in: superview as! UIWindow, position: position)

        NSLayoutConstraint.activate(positionConstraints)

        UIView.animate(withDuration: 0.3) { superview.layoutIfNeeded() }
    }

    /// Generates constraints based on the specified position.
    private static func constraints(for view: UIView, in window: UIWindow, position: ToastPosition) -> [NSLayoutConstraint] {
        switch position {
        case .topLeft:
            return [
                view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20),
                view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20)
            ]
        case .topCenter:
            return [
                view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20),
                view.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            ]
        case .topRight:
            return [
                view.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 20),
                view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
            ]
        case .middleLeft:
            return [
                view.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20)
            ]
        case .middleCenter:
            return [
                view.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            ]
        case .middleRight:
            return [
                view.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
            ]
        case .bottomLeft:
            return [
                view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20)
            ]
        case .bottomCenter:
            return [
                view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                view.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            ]
        case .bottomRight:
            return [
                view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20)
            ]
        }
    }

    /// Gets the active window for displaying the Toast.
    public static func getActiveWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .filter { $0.activationState == .foregroundActive }
                .flatMap(\.windows)
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first
        }
    }
}

// MARK: - ToastPosition Extensions

private extension ToastPosition {
    /// Checks if the position is in the bottom or middle regions.
    var isBottomOrMiddle: Bool {
        switch self {
        case .bottomLeft, .bottomCenter, .bottomRight, .middleLeft, .middleCenter, .middleRight:
            return true
        default:
            return false
        }
    }
}

