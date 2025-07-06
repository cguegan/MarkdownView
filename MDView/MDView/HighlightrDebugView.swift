//
//  HighlightrDebugView.swift
//  MDView
//
//  Debug view to test Highlightr themes and functionality
//

import SwiftUI
import Highlightr

struct HighlightrDebugView: View {
    @State private var selectedTheme = "default"
    @State private var themes: [String] = []
    @State private var highlightedCode: NSAttributedString?
    @State private var debugInfo = ""
    
    let testCode = """
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
    """
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Highlightr Theme Tester")
                .font(.title)
            
            // Theme picker
            if !themes.isEmpty {
                Picker("Theme", selection: $selectedTheme) {
                    ForEach(themes, id: \.self) { theme in
                        Text(theme).tag(theme)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedTheme) { _ in
                    applyTheme()
                }
            }
            
            // Debug info
            Text(debugInfo)
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Code display
            ScrollView {
                if let highlighted = highlightedCode {
                    #if os(macOS)
                    HighlightedTextView(attributedString: highlighted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    #else
                    Text("iOS display here")
                    #endif
                } else {
                    Text(testCode)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onAppear {
            loadThemes()
        }
    }
    
    func loadThemes() {
        guard let highlighter = Highlightr() else {
            debugInfo = "Failed to create Highlightr"
            return
        }
        
        themes = highlighter.availableThemes()
        debugInfo = "Found \(themes.count) themes"
        
        if let firstTheme = themes.first {
            selectedTheme = firstTheme
            applyTheme()
        }
    }
    
    func applyTheme() {
        guard let highlighter = Highlightr() else { return }
        
        debugInfo = "Applying theme: \(selectedTheme)"
        
        if highlighter.setTheme(to: selectedTheme) {
            if let highlighted = highlighter.highlight(testCode, as: "swift") {
                highlightedCode = highlighted
                
                // Debug: Check attributes
                var colorCount = 0
                var foundColors: Set<String> = []
                
                highlighted.enumerateAttributes(in: NSRange(location: 0, length: highlighted.length), options: []) { attributes, range, _ in
                    if let color = attributes[.foregroundColor] {
                        colorCount += 1
                        #if os(macOS)
                        if let nsColor = color as? NSColor {
                            foundColors.insert(nsColor.description)
                        }
                        #else
                        if let uiColor = color as? UIColor {
                            foundColors.insert(uiColor.description)
                        }
                        #endif
                    }
                }
                
                debugInfo = "Theme: \(selectedTheme) | Colors: \(colorCount) | Unique: \(foundColors.count)"
            } else {
                debugInfo = "Failed to highlight code"
            }
        } else {
            debugInfo = "Failed to set theme: \(selectedTheme)"
        }
    }
}

#if os(macOS)
struct HighlightedTextView: NSViewRepresentable {
    let attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        return textView
    }
    
    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.textStorage?.setAttributedString(attributedString)
        nsView.sizeToFit()
    }
}
#endif

#Preview {
    HighlightrDebugView()
        .frame(width: 600, height: 500)
}