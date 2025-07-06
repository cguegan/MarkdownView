//
//  TestHighlightView.swift
//  MDView
//
//  Test view to debug Highlightr functionality
//

import SwiftUI
import Highlightr

struct TestHighlightView: View {
    @State private var highlightedCode: NSAttributedString?
    
    let testCode = """
    func hello() {
        print("Hello, World!")
    }
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Highlightr Test")
                .font(.title)
            
            // Show raw code
            VStack(alignment: .leading) {
                Text("Raw Code:")
                    .font(.headline)
                Text(testCode)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Show highlighted code
            VStack(alignment: .leading) {
                Text("Highlighted Code:")
                    .font(.headline)
                
                if let highlighted = highlightedCode {
                    #if os(macOS)
                    // Try direct Text rendering
                    if let attributedString = try? AttributedString(highlighted, including: \.appKit) {
                        Text(attributedString)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        Text("Failed to convert to AttributedString")
                    }
                    #else
                    Text("iOS view would go here")
                    #endif
                } else {
                    Text("No highlighted code available")
                        .foregroundColor(.red)
                }
            }
            
            Button("Test Highlight") {
                testHighlight()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 600, height: 400)
        .onAppear {
            testHighlight()
        }
    }
    
    private func testHighlight() {
        guard let highlighter = Highlightr() else {
            print("❌ Failed to create Highlightr")
            return
        }
        
        print("✅ Created Highlightr")
        
        // List available themes
        let themes = highlighter.availableThemes()
        print("Available themes: \(themes.count)")
        print("First 5 themes: \(themes.prefix(5))")
        
        // Try to set theme
        let theme = "github"
        if highlighter.setTheme(to: theme) {
            print("✅ Set theme: \(theme)")
        } else {
            print("❌ Failed to set theme: \(theme)")
        }
        
        // Try to highlight
        if let highlighted = highlighter.highlight(testCode, as: "swift") {
            print("✅ Highlighted code successfully")
            print("Length: \(highlighted.length)")
            highlightedCode = highlighted
        } else {
            print("❌ Failed to highlight code")
        }
    }
}

#Preview {
    TestHighlightView()
}