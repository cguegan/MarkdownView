//
//  SMHeadingView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown headings (H1-H6) with appropriate styling.
///
/// This component takes a Markdown `Heading` object and renders it with:
/// - Font size based on heading level (1-6)
/// - Bold text styling
/// - Support for inline markdown formatting within the heading text
/// - A decorative underline separator
///
/// Example markdown:
/// ```markdown
/// # Heading 1
/// ## Heading 2 with **bold** text
/// ### Heading 3 with `code`
/// ```
struct SMHeading: View {

    /// The Markdown heading content from swift-markdown parser
    let content: Heading
    
    /// The heading level (1-6, corresponding to H1-H6 in HTML)
    let level: Int
    
    /// Initializes a new heading view with the given content and level
    /// - Parameters:
    ///   - content: The Heading object containing the markdown content
    ///   - level: The heading level from 1 (largest) to 6 (smallest)
    init(_ content: Heading, level: Int) {
        self.content = content
        self.level = level
    }
    
    /// Computed property that maps heading levels to appropriate SwiftUI fonts
    /// - Returns: A Font that corresponds to the heading level
    ///   - Level 1: `.largeTitle` (largest)
    ///   - Level 2: `.title`
    ///   - Level 3: `.title2`
    ///   - Level 4: `.title3`
    ///   - Level 5: `.headline`
    ///   - Level 6: `.subheadline` (smallest)
    ///   - Default: `.body` (fallback for invalid levels)
    var titleLevel: Font {
        switch level {
        case 1: .largeTitle
        case 2: .title
        case 3: .title2
        case 4: .title3
        case 5: .headline
        case 6: .subheadline
        default:.body
        }
    }
    
    /// Converts the heading's markdown content to an AttributedString
    /// This preserves inline formatting like bold, italic, and code
    /// - Returns: An AttributedString with markdown formatting applied
    var markdownText: AttributedString {
        do {
            // Use the format() method to get markdown string with inline formatting
            let markdownString = content.format()
            // Parse the markdown string to preserve inline styles
            return try AttributedString(markdown: markdownString)
        } catch {
            // Fallback to plain text if markdown parsing fails
            return AttributedString(content.plainText)
        }
    }
    
    /// The main view body that renders the heading
    var body: some View {
        VStack(alignment: .leading, spacing: 0 ) {
            // The heading text with appropriate font and styling
            Text(markdownText)
                .font(titleLevel)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            
            // Decorative underline separator
            Rectangle()
                .fill(Color.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .padding(.top, 4)
        }
        .padding(.horizontal)
    }
    
}

// MARK: - Subviews
// ————————————————

#Preview("Heading Levels") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(1...6, id: \.self) { level in
                SwiftMardownView(markdown: String(repeating: "#", count: level) + " Heading Level \(level)")
            }
            
            Divider()
            
            // Test with inline formatting
            SwiftMardownView(markdown: "## Heading with **bold** and *italic* text")
            SwiftMardownView(markdown: "### Heading with `inline code`")
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}
