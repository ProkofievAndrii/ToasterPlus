//
//  ToasterPosition.swift
//  Toaster
//
//  Created by Andrii Prokofiev on 16.11.2024.
//

import Foundation

/// Enum representing possible positions for displaying a toast.
///
/// Each toast can be displayed in one of the predefined positions
/// on the screen, offering flexibility in UI placement.
public enum ToastPosition {
    // MARK: - Positions

    /// Top-left corner of the screen.
    case topLeft

    /// Top-center of the screen.
    case topCenter

    /// Top-right corner of the screen.
    case topRight

    /// Middle-left of the screen.
    case middleLeft

    /// Center of the screen.
    case middleCenter

    /// Middle-right of the screen.
    case middleRight

    /// Bottom-left corner of the screen.
    case bottomLeft

    /// Bottom-center of the screen.
    case bottomCenter

    /// Bottom-right corner of the screen.
    case bottomRight

    // MARK: - Default Position

    /// The default position for a toast — bottom-center of the screen.
    public static let `default` = ToastPosition.bottomCenter
}
