//
//  BrandTheme.swift
//  SimpleProject
//
//  Design system v4 tokens for interactive controls.
//

import SwiftUI

enum Brand {
    /// Primary actions use the brand gradient instead of a flat fill.
    static let primaryGradient = LinearGradient(
        colors: [Color(red: 0.45, green: 0.33, blue: 0.95), Color(red: 0.16, green: 0.53, blue: 0.97)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Fill for a primary action that is currently unavailable.
    static let disabledFill = Color(uiColor: .tertiarySystemFill)

    /// Text fields sit on a filled surface rather than a hairline border.
    static let fieldFill = Color(uiColor: .secondarySystemBackground)

    /// Corner radii: buttons are softer than fields, fields softer than cards.
    static let buttonRadius: CGFloat = 14
    static let fieldRadius: CGFloat = 12

    /// Standard height for a full-width control.
    static let controlHeight: CGFloat = 52
}

/// Applies the v4 field treatment: filled surface, no border, roomier padding.
struct BrandFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .padding(.horizontal, 14)
            .frame(height: Brand.controlHeight)
            .background(Brand.fieldFill, in: RoundedRectangle(cornerRadius: Brand.fieldRadius))
    }
}

extension View {
    func brandField() -> some View {
        modifier(BrandFieldStyle())
    }
}
