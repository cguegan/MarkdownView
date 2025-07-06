//
//  SMCodeHighlighted.swift
//  MDView
//
//  Simple syntax highlighting for code blocks
//

import SwiftUI
import Markdown

struct SMCodeHighlighted: View {
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
            
            // Code content with basic highlighting
            ScrollView(.horizontal, showsIndicators: false) {
                highlightedCodeView
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
    
    @ViewBuilder
    private var highlightedCodeView: some View {
        if let attributedCode = getHighlightedCode() {
            Text(attributedCode)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
        } else {
            Text(code)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundColor(.primary)
        }
    }
    
    private func getHighlightedCode() -> AttributedString? {
        var attributedString = AttributedString(code)
        
        // Apply basic syntax highlighting based on language
        switch language {
        case "swift":
            highlightSwift(&attributedString)
        case "python", "py":
            highlightPython(&attributedString)
        case "javascript", "js", "jsx":
            highlightJavaScript(&attributedString)
        case "java":
            highlightJava(&attributedString)
        case "ruby", "rb":
            highlightRuby(&attributedString)
        case "json":
            highlightJSON(&attributedString)
        default:
            return nil // Return nil for unsupported languages
        }
        
        return attributedString
    }
    
    private func highlightSwift(_ attributedString: inout AttributedString) {
        let keywords = ["func", "var", "let", "class", "struct", "enum", "protocol", "extension",
                       "if", "else", "for", "while", "switch", "case", "default", "return",
                       "import", "private", "public", "internal", "static", "final", "override",
                       "init", "self", "Self", "@State", "@Binding", "@Published", "@ObservedObject",
                       "some", "any", "nil", "true", "false"]
        
        let types = ["String", "Int", "Double", "Float", "Bool", "Array", "Dictionary", "Set",
                    "View", "Text", "VStack", "HStack", "ZStack", "Button", "Image", "Color"]
        
        // Highlight keywords
        for keyword in keywords {
            highlightPattern(in: &attributedString, pattern: "\\b\(keyword)\\b", color: .purple, weight: .medium)
        }
        
        // Highlight types
        for type in types {
            highlightPattern(in: &attributedString, pattern: "\\b\(type)\\b", color: Color(red: 0.0, green: 0.5, blue: 0.8))
        }
        
        // Highlight strings
        highlightPattern(in: &attributedString, pattern: "\"[^\"]*\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        
        // Highlight comments
        highlightPattern(in: &attributedString, pattern: "//.*$", color: Color(red: 0.42, green: 0.47, blue: 0.53), isMultiline: true)
        highlightPattern(in: &attributedString, pattern: "/\\*[\\s\\S]*?\\*/", color: Color(red: 0.42, green: 0.47, blue: 0.53))
        
        // Highlight numbers
        highlightPattern(in: &attributedString, pattern: "\\b\\d+(\\.\\d+)?\\b", color: Color(red: 0.13, green: 0.43, blue: 0.85))
    }
    
    private func highlightPython(_ attributedString: inout AttributedString) {
        let keywords = ["def", "class", "if", "else", "elif", "for", "while", "try", "except",
                       "finally", "with", "as", "import", "from", "return", "yield", "lambda",
                       "and", "or", "not", "in", "is", "None", "True", "False", "self"]
        
        let builtins = ["print", "len", "range", "str", "int", "float", "list", "dict", "set",
                       "tuple", "bool", "type", "isinstance", "enumerate", "zip", "map", "filter"]
        
        // Highlight keywords
        for keyword in keywords {
            highlightPattern(in: &attributedString, pattern: "\\b\(keyword)\\b", color: .purple, weight: .medium)
        }
        
        // Highlight built-in functions
        for builtin in builtins {
            highlightPattern(in: &attributedString, pattern: "\\b\(builtin)\\b", color: Color(red: 0.0, green: 0.5, blue: 0.8))
        }
        
        // Highlight strings (both single and double quotes)
        highlightPattern(in: &attributedString, pattern: "\"[^\"]*\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        highlightPattern(in: &attributedString, pattern: "'[^']*'", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        highlightPattern(in: &attributedString, pattern: "\"\"\"[\\s\\S]*?\"\"\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        
        // Highlight comments
        highlightPattern(in: &attributedString, pattern: "#.*$", color: Color(red: 0.42, green: 0.47, blue: 0.53), isMultiline: true)
        
        // Highlight numbers
        highlightPattern(in: &attributedString, pattern: "\\b\\d+(\\.\\d+)?\\b", color: Color(red: 0.13, green: 0.43, blue: 0.85))
    }
    
    private func highlightJavaScript(_ attributedString: inout AttributedString) {
        let keywords = ["function", "var", "let", "const", "class", "extends", "if", "else",
                       "for", "while", "do", "switch", "case", "default", "return", "async",
                       "await", "try", "catch", "finally", "throw", "new", "this", "super",
                       "import", "export", "from", "default", "null", "undefined", "true", "false"]
        
        // Highlight keywords
        for keyword in keywords {
            highlightPattern(in: &attributedString, pattern: "\\b\(keyword)\\b", color: .purple, weight: .medium)
        }
        
        // Highlight strings
        highlightPattern(in: &attributedString, pattern: "\"[^\"]*\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        highlightPattern(in: &attributedString, pattern: "'[^']*'", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        highlightPattern(in: &attributedString, pattern: "`[^`]*`", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        
        // Highlight comments
        highlightPattern(in: &attributedString, pattern: "//.*$", color: Color(red: 0.42, green: 0.47, blue: 0.53), isMultiline: true)
        highlightPattern(in: &attributedString, pattern: "/\\*[\\s\\S]*?\\*/", color: Color(red: 0.42, green: 0.47, blue: 0.53))
        
        // Highlight numbers
        highlightPattern(in: &attributedString, pattern: "\\b\\d+(\\.\\d+)?\\b", color: Color(red: 0.13, green: 0.43, blue: 0.85))
    }
    
    private func highlightJava(_ attributedString: inout AttributedString) {
        let keywords = ["public", "private", "protected", "class", "interface", "extends", "implements",
                       "static", "final", "void", "int", "double", "float", "boolean", "char", "long",
                       "if", "else", "for", "while", "do", "switch", "case", "default", "return",
                       "try", "catch", "finally", "throw", "throws", "new", "this", "super", "import",
                       "package", "null", "true", "false"]
        
        // Highlight keywords
        for keyword in keywords {
            highlightPattern(in: &attributedString, pattern: "\\b\(keyword)\\b", color: .purple, weight: .medium)
        }
        
        // Highlight strings
        highlightPattern(in: &attributedString, pattern: "\"[^\"]*\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        
        // Highlight comments
        highlightPattern(in: &attributedString, pattern: "//.*$", color: Color(red: 0.42, green: 0.47, blue: 0.53), isMultiline: true)
        highlightPattern(in: &attributedString, pattern: "/\\*[\\s\\S]*?\\*/", color: Color(red: 0.42, green: 0.47, blue: 0.53))
        
        // Highlight numbers
        highlightPattern(in: &attributedString, pattern: "\\b\\d+(\\.\\d+)?[fFlL]?\\b", color: Color(red: 0.13, green: 0.43, blue: 0.85))
    }
    
    private func highlightRuby(_ attributedString: inout AttributedString) {
        let keywords = ["def", "class", "module", "if", "else", "elsif", "unless", "for", "while",
                       "do", "case", "when", "return", "yield", "begin", "rescue", "ensure", "end",
                       "and", "or", "not", "in", "self", "super", "nil", "true", "false", "require",
                       "include", "extend", "attr_reader", "attr_writer", "attr_accessor"]
        
        // Highlight keywords
        for keyword in keywords {
            highlightPattern(in: &attributedString, pattern: "\\b\(keyword)\\b", color: .purple, weight: .medium)
        }
        
        // Highlight strings
        highlightPattern(in: &attributedString, pattern: "\"[^\"]*\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        highlightPattern(in: &attributedString, pattern: "'[^']*'", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        
        // Highlight symbols
        highlightPattern(in: &attributedString, pattern: ":[a-zA-Z_][a-zA-Z0-9_]*", color: Color(red: 0.0, green: 0.5, blue: 0.5))
        
        // Highlight comments
        highlightPattern(in: &attributedString, pattern: "#.*$", color: Color(red: 0.42, green: 0.47, blue: 0.53), isMultiline: true)
        
        // Highlight numbers
        highlightPattern(in: &attributedString, pattern: "\\b\\d+(\\.\\d+)?\\b", color: Color(red: 0.13, green: 0.43, blue: 0.85))
    }
    
    private func highlightJSON(_ attributedString: inout AttributedString) {
        // Highlight property names
        highlightPattern(in: &attributedString, pattern: "\"[^\"]+\"\\s*:", color: Color(red: 0.0, green: 0.5, blue: 0.8))
        
        // Highlight string values
        highlightPattern(in: &attributedString, pattern: ":\\s*\"[^\"]*\"", color: Color(red: 0.77, green: 0.10, blue: 0.09))
        
        // Highlight booleans and null
        highlightPattern(in: &attributedString, pattern: "\\b(true|false|null)\\b", color: .purple, weight: .medium)
        
        // Highlight numbers
        highlightPattern(in: &attributedString, pattern: "\\b\\d+(\\.\\d+)?([eE][+-]?\\d+)?\\b", color: Color(red: 0.13, green: 0.43, blue: 0.85))
    }
    
    private func highlightPattern(in attributedString: inout AttributedString, 
                                 pattern: String, 
                                 color: Color, 
                                 weight: Font.Weight = .regular,
                                 isMultiline: Bool = false) {
        let string = String(attributedString.characters)
        
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: isMultiline ? [.anchorsMatchLines] : []
            )
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
            
            for match in matches {
                if let startIndex = attributedString.indexFromStart(offsetBy: match.range.location),
                   let endIndex = attributedString.indexFromStart(offsetBy: match.range.location + match.range.length) {
                    attributedString[startIndex..<endIndex].foregroundColor = color
                    if weight != .regular {
                        attributedString[startIndex..<endIndex].font = .system(size: 12, weight: weight, design: .monospaced)
                    }
                }
            }
        } catch {
            print("Regex error: \(error)")
        }
    }
}

// Helper extension for AttributedString index calculation
private extension AttributedString {
    func indexFromStart(offsetBy offset: Int) -> AttributedString.Index? {
        var currentIndex = startIndex
        var currentOffset = 0
        
        while currentOffset < offset && currentIndex < endIndex {
            currentIndex = index(after: currentIndex)
            currentOffset += 1
        }
        
        return currentOffset == offset ? currentIndex : nil
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
                # Calculate fibonacci number
                if n <= 1:
                    return n
                return fibonacci(n-1) + fibonacci(n-2)
            
            print(fibonacci(10))
            ```
            """)
        }
        .padding()
    }
}