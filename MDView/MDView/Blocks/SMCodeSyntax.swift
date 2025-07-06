//
//  SMCodeSyntax.swift
//  MDView
//
//  Simplified syntax highlighting for code blocks
//

import SwiftUI
import Markdown

struct SMCodeSyntax: View {
    let code: String
    let language: String?
    
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
                Text(highlightedCode)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
        }
        .background(Color(white: 0.95).opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var highlightedCode: AttributedString {
        var result = AttributedString(code)
        
        // Apply basic syntax highlighting based on language
        switch language {
        case "swift":
            applySwiftHighlighting(&result)
        case "python", "py":
            applyPythonHighlighting(&result)
        case "javascript", "js":
            applyJavaScriptHighlighting(&result)
        default:
            break
        }
        
        return result
    }
    
    private func applySwiftHighlighting(_ text: inout AttributedString) {
        // Keywords
        let keywords = ["func", "var", "let", "class", "struct", "enum", "if", "else", "return", "import", "for", "while"]
        highlightWords(in: &text, words: keywords, color: .purple, weight: .medium)
        
        // Types
        let types = ["String", "Int", "Double", "Bool", "View", "Text", "VStack", "HStack"]
        highlightWords(in: &text, words: types, color: Color(red: 0.0, green: 0.5, blue: 0.8))
        
        // Simple string highlighting
        highlightStrings(in: &text)
        
        // Simple comment highlighting
        highlightLineComments(in: &text)
    }
    
    private func applyPythonHighlighting(_ text: inout AttributedString) {
        // Keywords
        let keywords = ["def", "class", "if", "else", "elif", "for", "while", "return", "import", "from", "True", "False", "None"]
        highlightWords(in: &text, words: keywords, color: .purple, weight: .medium)
        
        // Built-ins
        let builtins = ["print", "len", "range", "str", "int", "float"]
        highlightWords(in: &text, words: builtins, color: Color(red: 0.0, green: 0.5, blue: 0.8))
        
        // Strings and comments
        highlightStrings(in: &text)
        highlightHashComments(in: &text)
    }
    
    private func applyJavaScriptHighlighting(_ text: inout AttributedString) {
        // Keywords
        let keywords = ["function", "var", "let", "const", "if", "else", "return", "for", "while", "class", "new"]
        highlightWords(in: &text, words: keywords, color: .purple, weight: .medium)
        
        // Strings and comments
        highlightStrings(in: &text)
        highlightLineComments(in: &text)
    }
    
    // Helper methods for highlighting
    private func highlightWords(in text: inout AttributedString, words: [String], color: Color, weight: Font.Weight = .regular) {
        let string = String(text.characters)
        
        for word in words {
            var searchRange = string.startIndex..<string.endIndex
            
            while let range = string.range(of: "\\b\(word)\\b", options: .regularExpression, range: searchRange) {
                if let attrRange = text.range(of: word) {
                    text[attrRange].foregroundColor = color
                    if weight != .regular {
                        text[attrRange].font = .system(size: 12, weight: weight, design: .monospaced)
                    }
                }
                searchRange = range.upperBound..<string.endIndex
            }
        }
    }
    
    private func highlightStrings(in text: inout AttributedString) {
        let string = String(text.characters)
        let color = Color(red: 0.77, green: 0.10, blue: 0.09)
        
        // Find double-quoted strings
        var searchRange = string.startIndex..<string.endIndex
        while let startQuote = string.range(of: "\"", range: searchRange) {
            searchRange = startQuote.upperBound..<string.endIndex
            if let endQuote = string.range(of: "\"", range: searchRange) {
                let fullRange = startQuote.lowerBound..<endQuote.upperBound
                let substring = String(string[fullRange])
                
                if let attrRange = text.range(of: substring) {
                    text[attrRange].foregroundColor = color
                }
                
                searchRange = endQuote.upperBound..<string.endIndex
            } else {
                break
            }
        }
    }
    
    private func highlightLineComments(in text: inout AttributedString) {
        let string = String(text.characters)
        let lines = string.split(separator: "\n", omittingEmptySubsequences: false)
        let color = Color(red: 0.42, green: 0.47, blue: 0.53)
        
        for line in lines {
            if let commentStart = line.range(of: "//") {
                let commentText = String(line[commentStart.lowerBound...])
                if let attrRange = text.range(of: commentText) {
                    text[attrRange].foregroundColor = color
                }
            }
        }
    }
    
    private func highlightHashComments(in text: inout AttributedString) {
        let string = String(text.characters)
        let lines = string.split(separator: "\n", omittingEmptySubsequences: false)
        let color = Color(red: 0.42, green: 0.47, blue: 0.53)
        
        for line in lines {
            if let commentStart = line.range(of: "#") {
                let commentText = String(line[commentStart.lowerBound...])
                if let attrRange = text.range(of: commentText) {
                    text[attrRange].foregroundColor = color
                }
            }
        }
    }
}

#Preview("Syntax Highlighting") {
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
                # Calculate fibonacci
                if n <= 1:
                    return n
                return fibonacci(n-1) + fibonacci(n-2)
            ```
            """)
        }
        .padding()
    }
}