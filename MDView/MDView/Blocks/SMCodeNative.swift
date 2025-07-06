//
//  SMCodeNative.swift
//  MDView
//
//  Native SwiftUI code block without external dependencies
//

import SwiftUI
import Markdown

struct SMCodeNative: View {
    let code: String
    let language: String?
    
    init(_ content: CodeBlock) {
        self.code = content.code.trimmingCharacters(in: .whitespacesAndNewlines)
        self.language = content.language
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
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
        }
        .background(backgroundGradient)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: 1)
        )
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(white: 0.95),
                Color(white: 0.98)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(0.5)
    }
    
    private var borderColor: Color {
        Color.secondary.opacity(0.2)
    }
}

#Preview("Code Blocks") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            SwiftMardownView(markdown: """
            ```swift
            struct ContentView: View {
                @State private var count = 0
                
                var body: some View {
                    VStack {
                        Text("Count: \\(count)")
                        Button("Increment") {
                            count += 1
                        }
                    }
                }
            }
            ```
            """)
            
            SwiftMardownView(markdown: """
            ```python
            def fibonacci(n):
                if n <= 1:
                    return n
                return fibonacci(n-1) + fibonacci(n-2)
            
            # Print first 10 Fibonacci numbers
            for i in range(10):
                print(f"F({i}) = {fibonacci(i)}")
            ```
            """)
            
            SwiftMardownView(markdown: """
            ```javascript
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
            }
            
            const calc = new Calculator();
            console.log(calc.add(5).multiply(3).result); // 15
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
    .frame(width: 700, height: 800)
}