//
//  SMCodeFixed.swift
//  MDView
//
//  Alternative implementation with better attributed string rendering
//

import SwiftUI
import Markdown
import Highlightr

struct SMCodeFixed: View {
    let code: String
    let language: String?
    @State private var highlightedCode: NSAttributedString?
    
    init(_ content: CodeBlock) {
        self.code = content.code.trimmingCharacters(in: .whitespacesAndNewlines)
        self.language = content.language
    }
    
    var body: some View {
        Group {
            if let highlighted = highlightedCode {
                // Use a simple Text view with the string value
                Text(highlighted.string)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(code)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .onAppear {
            highlightCode()
        }
    }
    
    private func highlightCode() {
        // Simple test without Highlightr first
        print("Code to highlight: \(code.prefix(50))...")
        print("Language: \(language ?? "none")")
        
        guard let highlighter = Highlightr() else {
            print("Failed to create Highlightr")
            return
        }
        
        // Use a known working theme
        let themes = highlighter.availableThemes()
        print("Available themes: \(themes.count)")
        
        // Try paraiso-dark as shown in the README example
        if highlighter.setTheme(to: "paraiso-dark") {
            print("Set theme: paraiso-dark")
        } else if let firstTheme = themes.first {
            highlighter.setTheme(to: firstTheme)
            print("Set theme: \(firstTheme)")
        }
        
        // Try highlighting
        if let highlighted = highlighter.highlight(code, as: language?.lowercased()) {
            print("Highlighting successful")
            highlightedCode = highlighted
        } else {
            print("Highlighting failed")
        }
    }
}