//
//  SMParagraph.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown paragraphs with full inline formatting support.
///
/// This component handles regular text paragraphs and preserves all inline markdown formatting:
/// - **Bold text** using `**text**` or `__text__`
/// - *Italic text* using `*text*` or `_text_`
/// - ***Bold italic*** combinations
/// - `Inline code` with backticks
/// - [Links](url) with proper tappable formatting
/// - ~~Strikethrough~~ text
/// - Nested formatting like **bold with *italic* inside**
///
/// The paragraph component automatically handles:
/// - Text wrapping for long content
/// - Proper line spacing for readability
/// - Consistent horizontal padding
/// - Natural text flow across multiple lines
///
/// Example markdown:
/// ```markdown
/// This is a paragraph with **bold**, *italic*, `code`, and [links](https://example.com).
/// ```
struct SMParagraph: View {
    
    /// The Paragraph content from the swift-markdown parser
    let content: Paragraph
    
    /// Initializes a new paragraph view with the given content
    /// - Parameter content: The Paragraph object containing the markdown text and inline elements
    init(_ content: Paragraph) {
        self.content = content
    }
    
    /// Converts the paragraph's content to an AttributedString, preserving all inline formatting
    ///
    /// This computed property:
    /// - Uses the `format()` method to get the complete markdown representation
    /// - Parses the markdown to create an AttributedString with proper styling
    /// - Handles all inline elements (bold, italic, code, links, etc.)
    /// - Falls back to plain text if parsing fails
    ///
    /// - Returns: An AttributedString with all markdown formatting applied
    var markdownText: AttributedString {
        do {
            // Use the format() method to get markdown string with all inline elements
            let markdownString = content.format()
            // Parse the markdown to create a properly styled AttributedString
            return try AttributedString(markdown: markdownString)
        } catch {
            // Fallback to plain text if markdown parsing fails
            // This ensures the content is always displayed, even if formatting is lost
            return AttributedString(content.plainText)
        }
    }
    
    /// The main view body that renders the paragraph
    var body: some View {
        Text(markdownText)
            .lineSpacing(4)                                      // Comfortable line spacing for readability
            .padding(.vertical, 6)                               // Vertical padding between paragraphs
            .frame(maxWidth: .infinity, alignment: .leading)     // Full width with left alignment
            .padding(.horizontal)                                // Consistent horizontal margins
    }
}


// MARK: - Subviews
// ————————————————

#Preview("Paragraph Styles") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            SwiftMardownView(markdown: "This is a simple paragraph with plain text.")
            
            SwiftMardownView(markdown: "This paragraph contains **bold text**, *italic text*, and ***bold italic text***.")
            
            SwiftMardownView(markdown: "This paragraph has `inline code` and a [link to GitHub](https://github.com).")
            
            SwiftMardownView(markdown: "This is a longer paragraph that demonstrates how text wrapping works in the markdown renderer. It contains multiple sentences and should flow naturally across multiple lines when the width is constrained.")
            
            SwiftMardownView(markdown: "Paragraph with ~~strikethrough~~ and mixed **bold with *nested italic* text**.")
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}

