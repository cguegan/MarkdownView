//
//  SMOrderedList.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown ordered (numbered) lists with support for nesting and mixed content.
///
/// This component provides comprehensive numbered list rendering with:
/// - Automatic numbering starting from 1 for each list level
/// - Multiple levels of nesting with proper indentation
/// - Support for mixed content (lists can contain paragraphs, code blocks, nested lists)
/// - Ability to mix ordered and unordered lists at different nesting levels
/// - Preservation of inline markdown formatting within list items
///
/// Features:
/// - **Automatic Numbering**: Each list level maintains its own numbering sequence
/// - **Nested Lists**: Supports unlimited nesting depth with progressive indentation
/// - **Mixed Lists**: Can contain both ordered and unordered nested lists
/// - **Rich Content**: List items can contain multiple block elements
/// - **Consistent Alignment**: Numbers are right-aligned for clean visual presentation
///
/// Example markdown:
/// ```markdown
/// 1. First item
/// 2. Second item with **bold**
///    1. Nested item one
///    2. Nested item two
/// 3. Third item with code block:
///    ```
///    code here
///    ```
/// ```
struct SMOrderedList: View {
    
    /// The OrderedList content from the swift-markdown parser
    let content: OrderedList
    
    /// The current indentation level (0 for root, increments for nested lists)
    /// Used to calculate proper visual indentation
    let indentLevel: Int
    
    /// Extracts all ListItem children from the OrderedList
    /// - Returns: Array of ListItem objects that make up this numbered list
    var items: [ListItem] {
        return content.children.compactMap { $0 as? ListItem }
    }
    
    /// Initializes a new ordered list view
    /// - Parameters:
    ///   - list: The OrderedList object containing the list content
    ///   - indentLevel: The nesting level (defaults to 0 for root lists)
    init(_ list: OrderedList, indentLevel: Int = 0) {
        self.content = list
        self.indentLevel = indentLevel
    }
    
    /// The main view body that renders the numbered list structure
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items.indices, id: \.self) { idx in
                let item = items[idx]
                renderListItem(item, index: idx)
            }
        }
        .padding(.top, indentLevel == 0 ? 0 : 3)  // Add small top padding for nested lists

    }
    
    /// Renders an individual list item with its number and content
    /// - Parameters:
    ///   - listItem: The ListItem to render
    ///   - index: The zero-based index used to calculate the display number
    /// - Returns: A view representing the formatted numbered list item
    func renderListItem(_ listItem: ListItem, index: Int) -> some View {
        HStack(alignment: .top, spacing: 8) {
            // Render the item number with proper formatting
            Text("\(index + 1).")
                .font(.system(.body, design: .default))
                .frame(minWidth: 20, alignment: .trailing)  // Right-align numbers
                .padding(.leading, 20)  // TODO: Should use progressive indentation like unordered lists
            
            // Render the list item content
            VStack(alignment: .leading, spacing: 0) {
                // Iterate through all block elements within the list item
                ForEach(Array(listItem.blockChildren.enumerated()), id: \.offset) { idx, block in
                    // Handle different types of content that can appear in list items
                    if let paragraph = block as? Paragraph {
                        // Regular text content with inline formatting
                        Text(getMarkdownText(from: paragraph))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(0)
                            .padding(.vertical, 0)
                    } else if let nestedList = block as? UnorderedList {
                        // Support mixing unordered lists within ordered lists
                        SMUnorderedList(nestedList, indentLevel: indentLevel + 1)
                    } else if let nestedOrderedList = block as? OrderedList {
                        // Nested ordered list (recursive)
                        SMOrderedList(nestedOrderedList, indentLevel: indentLevel + 1)
                    } else if let codeBlock = block as? CodeBlock {
                        // Code blocks within list items
                        SMCodeHighlighted(codeBlock)
                    } else {
                        // Fallback for any other block types
                        Text(block.format())
                    }
                }
            }
        }
    }
    
    /// Converts paragraph content to AttributedString, preserving inline formatting
    /// 
    /// Special handling includes:
    /// - Trimming whitespace to fix spacing issues in nested lists
    /// - Preserving all inline formatting (bold, italic, code, links)
    /// - Graceful fallback to plain text if parsing fails
    ///
    /// - Parameter paragraph: The Paragraph object to convert
    /// - Returns: An AttributedString with markdown formatting applied
    private func getMarkdownText(from paragraph: Paragraph) -> AttributedString {
        do {
            let markdownString = paragraph.format()
            // Trim whitespace to prevent excessive spacing in nested lists
            let trimmedMarkdownString = markdownString.trimmingCharacters(in: .whitespacesAndNewlines)
            return try AttributedString(markdown: trimmedMarkdownString)
        } catch {
            // Fallback to plain text if markdown parsing fails
            return AttributedString(paragraph.plainText)
        }
    }
     
    
}


// MARK: - Subviews
// ————————————————

#Preview("Ordered Lists") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            SwiftMardownView(markdown: """
            1. First item
            2. Second item
            3. Third item
            """)
            
            SwiftMardownView(markdown: """
            1. Item with **bold** text
            2. Item with *italic* text
            3. Item with `inline code`
            """)
            
            SwiftMardownView(markdown: """
            1. Main level item
                1. Nested item one
                2. Nested item two
                    1. Deep nested item
                    2. Another deep item
                3. Back to nested level
            2. Back to main level
            3. Another main item
            """)
            
            SwiftMardownView(markdown: """
            1. Mixed list types
                - Unordered sub-item
                - Another unordered item
            2. Back to ordered
                1. Nested ordered
                2. Another nested
            """)
            
            SwiftMardownView(markdown: """
            1. Long ordered list item that contains a lot of text and should wrap to multiple lines when displayed in the markdown renderer
            2. Short item
            3. Another long item with **bold text** and *italic text* that demonstrates how inline formatting works within ordered list items
            """)
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}
