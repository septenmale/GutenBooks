//
//  EmptyStateView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 04/02/2026.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var buttonTitle: String? = nil
    var buttonAction: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color(.tertiarySystemFill))
                        .frame(width: 96, height: 96)
                    Image(systemName: icon)
                        .font(.system(size: 36, weight: .regular))
                        .foregroundStyle(.tertiary)
                }
                VStack(spacing: 8) {
                    Text(title)
                        .font(.title2.bold())
                    Text(subtitle)
                        .font(.default)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                if let buttonTitle, let action = buttonAction {
                    Button(action: action) {
                        Text(buttonTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 32)
                }
            }
            .padding()
        }
    }
}

#Preview("Without icon") {
    EmptyStateView(icon: "heart",
                   title: "No favorites yet",
                   subtitle: "Tap the heart icon on any book to add it to your collection and see it here."
    )}

#Preview("With icon") {
    EmptyStateView(icon: "heart",
                   title: "No favorites yet",
                   subtitle: "Tap the heart icon on any book to add it to your collection and see it here.",
                   buttonTitle: "Add to favorites",
                   buttonAction: { print("Add to favorites tapped") }
    )}
