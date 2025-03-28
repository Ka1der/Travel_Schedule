//
//  ViewModifiers.swift
//  Travel_Schedule
//
//  Created by Kaider on 27.03.2025.
//

import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(Color(uiColor: .systemGray5))
            )
            .padding(.horizontal, 16)
    }
}

struct LogoContainerModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 38, height: 38)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 4)
            )
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackgroundModifier())
    }
    
    func logoContainer() -> some View {
        modifier(LogoContainerModifier())
    }
}
