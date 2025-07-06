//
//  SMCode.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown
import Highlightr

struct SMCode: View {
    
    let code: String
    let language: String?
    @State private var highlightedCode: NSAttributedString?
    @Environment(\.colorScheme) var colorScheme
    
    ///  Initialisation
    init(_ content: CodeBlock) {
        self.code = content.code
            .trimmingCharacters(in: .whitespacesAndNewlines)
        self.language = content.language
    }
    
    /// Main Body
    var body: some View {
        Group {
            #if os(macOS)
            // For macOS, try using Text with AttributedString first
            if let attributedString = highlightedCode,
               let swiftUIAttributedString = try? AttributedString(attributedString, including: \.appKit) {
                Text(swiftUIAttributedString)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else if let attributedString = highlightedCode {
                // Fallback to NSViewRepresentable if AttributedString conversion fails
                HighlightedCodeView(attributedString: attributedString)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                // Fallback to plain text
                Text(code)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            #else
            if let attributedString = highlightedCode {
                // Use highlighted code
                HighlightedCodeView(attributedString: attributedString)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                // Fallback to plain text
                Text(code)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            #endif
        }
        .padding()
        .background(backgroundColorForPlatform)
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
        guard let highlighter = Highlightr() else {
            print("Failed to create Highlightr instance")
            return
        }
        
        // Configure code font
        #if os(macOS)
        highlighter.theme.codeFont = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        #else
        highlighter.theme.codeFont = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        #endif
        
        // Try different themes based on color scheme
        let themeName = colorScheme == .dark ? "monokai" : "github"
        
        // Set the theme
        if !highlighter.setTheme(to: themeName) {
            print("Failed to set theme: \(themeName)")
            // Try fallback themes
            let fallbackThemes = ["xcode", "default", "atom-one-light"]
            for fallback in fallbackThemes {
                if highlighter.setTheme(to: fallback) {
                    print("Using fallback theme: \(fallback)")
                    break
                }
            }
        }
        
        // Debug: Print available themes
        let themes = highlighter.availableThemes()
        if !themes.isEmpty {
            print("Available themes: \(themes.prefix(10).joined(separator: ", "))...")
        }
        print("Highlighting code with language: \(language ?? "plaintext")")
        
        // Highlight the code - use the exact language or nil for auto-detection
        if let highlighted = highlighter.highlight(code, as: language) {
            highlightedCode = highlighted
            print("Successfully highlighted code with \(highlighted.length) characters")
        } else {
            print("Failed to highlight code - trying without language specification")
            // Try without language specification
            if let highlighted = highlighter.highlight(code) {
                highlightedCode = highlighted
                print("Successfully highlighted code without language")
            }
        }
    }
    
    private var backgroundColorForPlatform: Color {
        #if os(macOS)
        return Color(NSColor.windowBackgroundColor).opacity(0.5)
        #else
        return Color(.systemGray6)
        #endif
    }
}

// Helper view to display NSAttributedString
#if os(macOS)
struct HighlightedCodeView: NSViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = NSSize(width: 0, height: 0)
        textView.textContainer?.lineFragmentPadding = 0
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.autoresizingMask = [.width]
        
        // Set a default font if none is provided
        textView.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        
        scrollView.documentView = textView
        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        
        // Store the attributed string
        textView.textStorage?.setAttributedString(attributedString)
        
        // Force layout update
        textView.sizeToFit()
        
        // Calculate the required height
        if let textContainer = textView.textContainer,
           let layoutManager = textView.layoutManager {
            layoutManager.ensureLayout(for: textContainer)
            let usedRect = layoutManager.usedRect(for: textContainer)
            let height = usedRect.height + textView.textContainerInset.height * 2
            
            // Update the frame
            textView.setFrameSize(NSSize(width: textView.frame.width, height: height))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        // Can be used for delegate methods if needed
    }
}
#elseif os(iOS)
struct HighlightedCodeView: UIViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }
}
#endif


//#Preview {
//    SMParagraph()
//}

