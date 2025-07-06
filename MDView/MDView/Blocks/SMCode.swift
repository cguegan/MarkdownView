//
//  SMCode.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown
import Highlightr

/// A SwiftUI view component that renders Markdown code blocks with syntax highlighting.
///
/// This component provides professional code display with:
/// - Syntax highlighting using the Highlightr library
/// - Automatic language detection when no language is specified
/// - Theme adaptation based on system color scheme (light/dark mode)
/// - Horizontal scrolling for long lines of code
/// - Optional language label display
/// - Text selection support for copying code
///
/// Features:
/// - **Language Support**: Highlights code based on the specified language in markdown
/// - **Theme Adaptation**: Automatically switches between light and dark themes
/// - **Fallback Rendering**: Shows plain monospaced text if highlighting fails
/// - **Cross-Platform**: Works on both iOS and macOS with platform-specific text views
///
/// Example markdown:
/// ```markdown
/// ```swift
/// let greeting = "Hello, World!"
/// print(greeting)
/// ```
/// 
/// ```python
/// def greet(name):
///     return f"Hello, {name}!"
/// ```
/// ```
struct SMCode: View {
    /// The raw code content to be displayed
    let code: String
    
    /// The programming language for syntax highlighting (e.g., "swift", "python")
    /// If nil, Highlightr will attempt to auto-detect the language
    let language: String?
    
    /// Stores the syntax-highlighted version of the code
    @State private var highlightedCode: NSAttributedString?
    
    /// Tracks the current color scheme to apply appropriate theme
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
    
    /// Configures syntax highlighting based on language and color scheme
    /// 
    /// This method:
    /// 1. Creates a Highlightr instance
    /// 2. Selects an appropriate theme based on the color scheme
    /// 3. Attempts to highlight the code with the specified language
    /// 4. Falls back to auto-detection if language-specific highlighting fails
    /// 5. Updates the UI on the main thread when complete
    private func setupHighlighting() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let highlighter = Highlightr() else {
                print("Failed to create Highlightr")
                return
            }
            
            // Get all available syntax highlighting themes
            let themes = highlighter.availableThemes()
            print("Available themes: \(themes.prefix(10).joined(separator: ", "))")
            
            // Select theme based on color scheme with fallback options
            let themeName: String
            if colorScheme == .dark {
                // Dark themes ordered by preference for better readability
                let darkThemes = ["vs2015", "monokai", "atom-one-dark", "tomorrow-night", "solarized-dark"]
                themeName = darkThemes.first(where: { themes.contains($0) }) ?? themes.first ?? "default"
            } else {
                // Light themes ordered by preference for better readability
                let lightThemes = ["github", "xcode", "vs", "atom-one-light", "solarized-light"]
                themeName = lightThemes.first(where: { themes.contains($0) }) ?? themes.first ?? "default"
            }
            
            let themeSet = highlighter.setTheme(to: themeName)
            print("Theme '\(themeName)' set: \(themeSet)")
            
            // Attempt syntax highlighting with multiple fallback strategies
            let highlighted: NSAttributedString?
            if let lang = language {
                // Try language-specific highlighting with fast render first (better performance)
                highlighted = highlighter.highlight(code, as: lang, fastRender: true)
                    ?? highlighter.highlight(code, as: lang) // Fallback: Try without fast render
                    ?? highlighter.highlight(code) // Final fallback: Auto-detect language
            } else {
                // No language specified: Let Highlightr auto-detect
                highlighted = highlighter.highlight(code)
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

/// A wrapper view for displaying highlighted code with horizontal scrolling
/// 
/// This view provides a scrollable container for the attributed string,
/// ensuring long lines of code can be viewed by scrolling horizontally.
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

/// Bridge component to display NSAttributedString in SwiftUI
/// 
/// This view attempts to convert NSAttributedString to SwiftUI's AttributedString
/// for better integration, falling back to platform-specific views when needed.
struct AttributedText: View {
    let attributedString: NSAttributedString
    
    var body: some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            // Attempt conversion to native SwiftUI AttributedString for better performance
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
/// Platform-specific text view for macOS using NSTextView
/// 
/// Provides a native macOS text view for displaying syntax-highlighted code
/// with proper text selection and monospace font rendering.
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
        
        // Ensure monospace font for code readability
        if nsView.font == nil {
            nsView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        }
    }
}
#else
/// Platform-specific text view for iOS using UITextView
/// 
/// Provides a native iOS text view for displaying syntax-highlighted code
/// with proper text selection and monospace font rendering.
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