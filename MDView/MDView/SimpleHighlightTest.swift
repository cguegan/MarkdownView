//
//  SimpleHighlightTest.swift
//  MDView
//
//  Minimal test to verify Highlightr functionality
//

import SwiftUI
import Highlightr

struct SimpleHighlightTest: View {
    @State private var result: String = "Testing..."
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Highlightr Direct Test")
                .font(.title)
            
            Text(result)
                .font(.system(.body, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
            
            Button("Run Test") {
                runTest()
            }
        }
        .padding()
        .onAppear {
            runTest()
        }
    }
    
    func runTest() {
        var output = ""
        
        // Test 1: Create Highlightr
        if let highlighter = Highlightr() {
            output += "✅ Highlightr created\n"
            
            // Test 2: Check themes
            let themes = highlighter.availableThemes()
            output += "✅ Themes available: \(themes.count)\n"
            if !themes.isEmpty {
                output += "   Sample themes: \(themes.prefix(3).joined(separator: ", "))\n"
            }
            
            // Test 3: Set theme
            let testTheme = "default"
            if highlighter.setTheme(to: testTheme) {
                output += "✅ Theme set: \(testTheme)\n"
            } else {
                output += "❌ Failed to set theme: \(testTheme)\n"
                // Try first available theme
                if let firstTheme = themes.first {
                    if highlighter.setTheme(to: firstTheme) {
                        output += "✅ Fallback theme set: \(firstTheme)\n"
                    }
                }
            }
            
            // Test 4: Simple highlight
            let code = "let x = 42"
            if let highlighted = highlighter.highlight(code, as: "swift") {
                output += "✅ Code highlighted (length: \(highlighted.length))\n"
                
                // Check if it has attributes
                var hasColor = false
                highlighted.enumerateAttributes(in: NSRange(location: 0, length: highlighted.length), options: []) { attributes, range, _ in
                    if attributes[.foregroundColor] != nil {
                        hasColor = true
                    }
                }
                output += hasColor ? "✅ Has color attributes\n" : "❌ No color attributes\n"
            } else {
                output += "❌ Failed to highlight code\n"
            }
            
        } else {
            output += "❌ Failed to create Highlightr\n"
        }
        
        result = output
    }
}

#Preview {
    SimpleHighlightTest()
}