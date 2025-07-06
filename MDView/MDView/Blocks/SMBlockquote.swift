//
//  SMBlockquote.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown blockquotes with visual styling.
///
/// This component provides a visually distinct presentation for quoted content with:
/// - A prominent left border indicator
/// - Light background highlighting
/// - Support for nested blockquotes
/// - Ability to contain various block elements (paragraphs, headings, lists, code blocks)
/// - Preserves inline markdown formatting within the blockquote
///
/// Example markdown:
/// ```markdown
/// > This is a simple blockquote
/// > with multiple lines.
///
/// > ## Blockquote with heading
/// > And some regular text
///
/// >> Nested blockquote
/// > Back to first level
/// ```
struct SMBlockquote: View {

    /// The BlockQuote content from the swift-markdown parser
    let content: BlockQuote
    
    /// Initializes a new blockquote view with the given content
    /// - Parameter content: The BlockQuote object containing the quoted markdown content
    init(_ content: BlockQuote) {
        self.content = content
    }
    
    /// The main view body that renders the blockquote with its visual styling
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Iterate through all child blocks within the blockquote
            ForEach(Array(content.blockChildren.enumerated()), id: \.offset) { _, block in
                // Handle different types of block content that can appear in blockquotes
                if let paragraph = block as? Paragraph {
                    // Render paragraph with preserved inline formatting
                    Text(getMarkdownText(from: paragraph))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if let heading = block as? Heading {
                    // Render headings within blockquotes
                    SMHeading(heading, level: heading.level)
                } else if let list = block as? UnorderedList {
                    // Support unordered lists in blockquotes
                    SMUnorderedList(list)
                } else if let orderedList = block as? OrderedList {
                    // Support ordered lists in blockquotes
                    SMOrderedList(orderedList)
                } else if let nestedQuote = block as? BlockQuote {
                    // Support nested blockquotes (recursive)
                    SMBlockquote(nestedQuote)
                } else if let codeBlock = block as? CodeBlock {
                    // Support code blocks within blockquotes
                    SMCode(codeBlock)
                } else {
                    // Fallback for any other block types
                    Text(block.format())
                }
            }
        }
        .lineSpacing(4)
        .padding(.leading, 18)  // Extra left padding for the border
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))  // Light background tint
        .overlay() {
            // Left border indicator
            HStack {
                Rectangle()
                    .foregroundStyle(.secondary)
                    .frame(width: 6, alignment: .leading)
                Spacer()
            }
        }
        .cornerRadius(6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 6)
        .padding(.horizontal)
    }
    
    /// Converts paragraph content to AttributedString, preserving inline markdown formatting
    /// - Parameter paragraph: The Paragraph object to convert
    /// - Returns: An AttributedString with markdown formatting applied (bold, italic, links, etc.)
    private func getMarkdownText(from paragraph: Paragraph) -> AttributedString {
        do {
            // Get the formatted markdown string
            let markdownString = paragraph.format()
            // Parse as AttributedString to preserve inline styles
            return try AttributedString(markdown: markdownString)
        } catch {
            // Fallback to plain text if parsing fails
            return AttributedString(paragraph.plainText)
        }
    }
    
}


// MARK: - Subviews
// ————————————————

#Preview("Blockquotes") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            SwiftMardownView(markdown: "> This is a simple blockquote.")
            
            SwiftMardownView(markdown: "> This is a blockquote with **bold** and *italic* text.")
            
            SwiftMardownView(markdown: """
            > This is a multi-line blockquote.
            > It continues on the second line.
            > And even has a third line.
            """)
            
            SwiftMardownView(markdown: """
            > ## Blockquote with heading
            > This blockquote contains a heading and some regular text below it.
            """)
            
            SwiftMardownView(markdown: """
            > Nested blockquotes are also possible:
            >> This is a nested blockquote
            >> with multiple lines
            > Back to the first level
            """)
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}
