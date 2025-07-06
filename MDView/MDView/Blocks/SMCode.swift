//
//  SMCode.swift
//  MDView
//
//  Code highlighting using Highlightr with proper setup
//

import SwiftUI
import Markdown
import Highlightr

struct SMCode: View {
    let code: String
    let language: String?
    @State private var highlightedCode: NSAttributedString?
    @Environment(\.colorScheme) var colorScheme
    
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
            Group {
                if let highlighted = highlightedCode {
                    // Use the highlighted version
                    CodeTextView(attributedString: highlighted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    // Fallback to plain text
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(code)
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .textSelection(.enabled)
                    }
                }
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
        .onAppear {
            setupHighlighting()
        }
        .onChange(of: colorScheme) { _ in
            setupHighlighting()
        }
    }
    
    private func setupHighlighting() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let highlighter = Highlightr() else {
                print("Failed to create Highlightr")
                return
            }
            
            // Debug: List available themes
            let themes = highlighter.availableThemes()
            print("Available themes: \(themes.prefix(10).joined(separator: ", "))")
            
            // Try to set an appropriate theme
            let themeName: String
            if colorScheme == .dark {
                // Try dark themes in order of preference
                let darkThemes = ["vs2015", "monokai", "atom-one-dark", "tomorrow-night", "solarized-dark"]
                themeName = darkThemes.first(where: { themes.contains($0) }) ?? themes.first ?? "default"
            } else {
                // Try light themes in order of preference
                let lightThemes = ["github", "xcode", "vs", "atom-one-light", "solarized-light"]
                themeName = lightThemes.first(where: { themes.contains($0) }) ?? themes.first ?? "default"
            }
            
            let themeSet = highlighter.setTheme(to: themeName)
            print("Theme '\(themeName)' set: \(themeSet)")
            
            // Try to highlight with the specified language
            let highlighted: NSAttributedString?
            if let lang = language {
                highlighted = highlighter.highlight(code, as: lang, fastRender: true)
                    ?? highlighter.highlight(code, as: lang) // Try without fast render
                    ?? highlighter.highlight(code) // Try auto-detection
            } else {
                highlighted = highlighter.highlight(code) // Auto-detect
            }
            
            if let highlighted = highlighted {
                print("Successfully highlighted code")
                DispatchQueue.main.async {
                    self.highlightedCode = highlighted
                }
            } else {
                print("Failed to highlight code")
            }
        }
    }
}

// Custom view to display NSAttributedString
struct CodeTextView: View {
    let attributedString: NSAttributedString
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            AttributedText(attributedString: attributedString)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Bridge to display NSAttributedString in SwiftUI
struct AttributedText: View {
    let attributedString: NSAttributedString
    
    var body: some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            // Try to convert to SwiftUI AttributedString
            if let swiftUIAttrString = try? AttributedString(attributedString, including: \.uiKit) {
                Text(swiftUIAttrString)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .textSelection(.enabled)
            } else {
                // Fallback to platform-specific view
                PlatformAttributedText(attributedString: attributedString)
            }
        } else {
            PlatformAttributedText(attributedString: attributedString)
        }
    }
}

#if os(macOS)
struct PlatformAttributedText: NSViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(attributedString)
        
        // Set a default font if needed
        if nsView.font == nil {
            nsView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        }
    }
}
#else
struct PlatformAttributedText: UIViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.isScrollEnabled = false
        textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
}
#endif

#Preview("Highlightr Test") {
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
        }
        .padding()
    }
}