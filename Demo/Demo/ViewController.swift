//
//  ViewController.swift
//  Demo
//
//  Created by Andrii Prokofiev on 16.11.2024.
//

import UIKit
import Toaster

/// Example view controller demonstrating the use of the Toaster framework.
class ViewController: UIViewController {
    
    // MARK: - UI Elements (Storyboard-linked)
    
    /// Button to add a single Toast to the queue.
    @IBOutlet private weak var addOneButton: UIButton!
    
    /// Button to clear the current Toast.
    @IBOutlet private weak var clearCurrentButton: UIButton!
    
    /// Button to clear all Toasts in the queue.
    @IBOutlet private weak var clearAllButton: UIButton!
    
    /// Button to toggle the keyboard visibility.
    @IBOutlet private weak var toggleKeyboardButton: UIButton!
    
    /// TextField to demonstrate keyboard interactions.
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Properties
    
    /// Tracks the visibility of the keyboard.
    private var isKeyboardVisible = false
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToastAppearance() // Customizes default Toast appearance.
        showExampleToasts() // Demonstrates various Toast configurations.
    }
    
    // MARK: - Toast Configuration
    
    /// Configures the default appearance of Toasts.
    private func configureToastAppearance() {
        ToastAppearance.default.backgroundColor = .systemBlue
        ToastAppearance.default.textColor = .white
        ToastAppearance.default.font = UIFont.boldSystemFont(ofSize: 18)
        ToastAppearance.default.cornerRadius = 12
        ToastAppearance.default.textInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        ToastAppearance.default.shadowColor = .gray
        ToastAppearance.default.shadowOpacity = 0.5
        ToastAppearance.default.shadowRadius = 6
        ToastAppearance.default.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    // MARK: - Toast Demonstrations
    
    /// Demonstrates various examples of Toasts with different configurations.
    private func showExampleToasts() {
        // Basic Toasts
        Toast(message: "First Toast")
        Toast(message: "Second Toast")
        Toast(message: "Third Toast")
        
        // Toast with delay and custom duration
        let delayedToast = Toast(
            message: "This toast appears after a delay",
            duration: Delay.long,
            delay: 2.0
        )
        delayedToast.cancel() // Demonstrates cancellation of a Toast.
        
        // Toast with attributed text
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
        
        // Preset Toasts (Success, Error, Warning)
        Toast.success(message: "Operation completed successfully!", position: .bottomLeft)
        Toast.error(message: "An error occurred while saving data.", position: .topRight)
        Toast.warning(message: "Please check your input.", position: .middleCenter)
        
        // Toasts at various positions
        let positions: [ToastPosition] = [
            .topLeft, .topCenter, .topRight,
            .middleLeft, .middleCenter, .middleRight,
            .bottomLeft, .bottomCenter, .bottomRight
        ]
        for position in positions {
            Toast(message: "\(position) Toast", position: position)
        }
        
        // Custom appearance Toast
        var customAppearance = ToastAppearance()
        customAppearance.backgroundColor = .purple
        customAppearance.textColor = .yellow
        customAppearance.font = .italicSystemFont(ofSize: 16)
        Toast(
            message: "Custom Appearance Toast",
            position: .middleRight,
            appearance: customAppearance
        )
    }
    
    // MARK: - Button Actions
    
    /// Adds a new Toast to the queue when the button is tapped.
    @IBAction func addToastButtonTapped(_ sender: UIButton) {
        Toast(message: "Toast from button!")
    }
    
    /// Clears the currently visible Toast when the button is tapped.
    @IBAction func clearCurrentButtonTapped(_ sender: UIButton) {
        ToastCenter.default.cancelCurrentToast()
    }
    
    /// Clears all Toasts in the queue when the button is tapped.
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        ToastCenter.default.cancelAll()
    }
    
    /// Toggles the visibility of the keyboard.
    @IBAction func toggleKeyboardButtonTapped(_ sender: UIButton) {
        if isKeyboardVisible {
            hideKeyboard()
        } else {
            textField.becomeFirstResponder()
        }
    }
}

// MARK: - Keyboard Handling
extension ViewController {
    /// Hides the keyboard programmatically.
    @objc private func hideKeyboard() {
        textField.resignFirstResponder()
        view.endEditing(true)
        isKeyboardVisible = false
    }

    /// Monitors keyboard visibility when the view is about to appear.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// Removes keyboard notification observers when the view is about to disappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// Updates the flag when the keyboard is shown.
    @objc private func keyboardWillShow(_ notification: Notification) {
        isKeyboardVisible = true
    }

    /// Updates the flag when the keyboard is hidden.
    @objc private func keyboardWillHide(_ notification: Notification) {
        isKeyboardVisible = false
    }
}
