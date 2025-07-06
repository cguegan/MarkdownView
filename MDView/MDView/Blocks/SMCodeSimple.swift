//
//  SMCodeSimple.swift
//  MDView
//
//  Alternative simple code block implementation
//

import SwiftUI
import Markdown

struct SMCodeSimple: View {
    let code: String
    let language: String?
    
    init(_ content: CodeBlock) {
        self.code = content.code
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.language = content.language
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Show language label if available
            if let language = language {
                Text(language)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            // Use ScrollView for long code
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(Color.secondary.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// MARK: - Subviews
// ————————————————
