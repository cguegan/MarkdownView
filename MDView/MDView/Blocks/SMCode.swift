//
//  SMCode.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown code blocks with simple styling.
///
/// This component provides a clean code display with:
/// - Monospaced font for code readability
/// - Optional language label display
/// - Horizontal scrolling for long lines
/// - Adaptive colors for light/dark mode
/// - Text selection support
///
/// Example markdown:
/// ```markdown
/// ```swift
/// let greeting = "Hello, World!"
/// print(greeting)
/// ```
/// ```
struct SMCode: View {
    /// The raw code content to be displayed
    let code: String
    
    /// The programming language label (e.g., "swift", "python")
    let language: String?
    
    /// Tracks the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    /// Initializes a new code block view from markdown content
    /// - Parameter content: The CodeBlock object from swift-markdown parser
    init(_ content: CodeBlock) {
        self.code = content.code.trimmingCharacters(in: .whitespacesAndNewlines)
        self.language = content.language?.lowercased()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Language label
            if let language = language {
                HStack {
                    Text(language.uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            
            // Code content
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
        }
        .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

// MARK: - Previews
// ————————————————

#Preview("Code Blocks") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            SwiftMardownView(markdown: """
            ```swift
            // Swift example
            struct ContentView: View {
                @State private var count = 0
                
                var body: some View {
                    VStack {
                        Text("Count: \\(count)")
                            .font(.largeTitle)
                        
                        Button("Increment") {
                            count += 1
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            ```
            """)
            
            SwiftMardownView(markdown: """
            ```python
            # Python example
            def fibonacci(n):
                '''Calculate fibonacci number recursively'''
                if n <= 1:
                    return n
                return fibonacci(n-1) + fibonacci(n-2)
            
            # Test the function
            for i in range(10):
                print(f"F({i}) = {fibonacci(i)}")
            ```
            """)
            
            SwiftMardownView(markdown: """
            ```javascript
            // JavaScript example
            class Calculator {
                constructor() {
                    this.result = 0;
                }
                
                add(value) {
                    this.result += value;
                    return this;
                }
                
                multiply(value) {
                    this.result *= value;
                    return this;
                }
                
                getResult() {
                    return this.result;
                }
            }
            
            const calc = new Calculator();
            console.log(calc.add(5).multiply(3).getResult()); // 15
            ```
            """)
            
            SwiftMardownView(markdown: """
            ```
            // Code block without language specification
            function example() {
                return "No syntax highlighting";
            }
            ```
            """)
        }
        .padding()
    }
}
