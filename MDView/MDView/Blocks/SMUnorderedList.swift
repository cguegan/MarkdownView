//
//  SMUnorderedListView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown unordered lists with support for nested lists and task lists.
///
/// This component provides comprehensive list rendering with:
/// - Standard bullet points for regular list items
/// - GitHub-style task lists with interactive checkboxes
/// - Multiple levels of nesting with proper indentation
/// - Support for mixed content (lists can contain paragraphs, code blocks, nested lists)
/// - Preservation of inline markdown formatting within list items
///
/// Features:
/// - **Regular Lists**: Uses filled circles as bullet points
/// - **Task Lists**: Displays checkboxes (checked/unchecked) using SF Symbols
/// - **Nested Lists**: Supports unlimited nesting depth with progressive indentation
/// - **Mixed Content**: List items can contain multiple block elements
///
/// Example markdown:
/// ```markdown
/// - Simple list item
/// - Item with **bold** and *italic*
///   - Nested item
///   - Another nested item
/// 
/// - [ ] Unchecked task
/// - [x] Completed task
///   - [x] Nested completed task
/// ```
struct SMUnorderedList: View {
    
    /// The UnorderedList content from the swift-markdown parser
    /// 
    let content: UnorderedList
    
    /// The current indentation level (0 for root, increments for nested lists)
    /// Used to calculate proper visual indentation
    ///
    let indentLevel: Int
    
    /// Extracts all ListItem children from the UnorderedList
    /// - Returns: Array of ListItem objects that make up this list
    ///
    var items: [ListItem] {
        return content.children.compactMap { $0 as? ListItem }
    }
    
    /// Initializes a new unordered list view
    /// - Parameters:
    ///   - list: The UnorderedList object containing the list content
    ///   - indentLevel: The nesting level (defaults to 0 for root lists)
    ///
    init(_ list: UnorderedList, indentLevel: Int = 0) {
        self.content = list
        self.indentLevel = indentLevel
    }
    
    /// The main view body that renders the list structure
    ///
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items.indices, id: \.self) { idx in
                let item = items[idx]
                renderListItem(item)
            }
        }
        // Add small top padding for nested lists
        .padding(.top, indentLevel == 0 ? 0 : 3)

    }
    
    /// Renders an individual list item with its bullet/checkbox and content
    /// - Parameter listItem: The ListItem to render
    /// - Returns: A view representing the formatted list item
    ///
    func renderListItem(_ listItem: ListItem) -> some View {
        HStack(alignment: .top, spacing: 8) {
            
            // Render the bullet point or checkbox
            if let checkbox = listItem.checkbox {
                // Task list item with checkbox
                Image(systemName: checkbox == .checked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 16))
                    .foregroundColor(checkbox == .checked ? .accentColor : .secondary)
                    .padding(.leading, CGFloat(16 + (indentLevel * 24)))  // Progressive indentation
                    .padding(.top, 2)  // Align checkbox with text baseline
            } else {
                // Regular bulleted list item
                Image(systemName: "circle.fill")
                    .font(.system(size: 6))
                    .padding(.leading, CGFloat(16 + (indentLevel * 24)))  // Progressive indentation
                    .padding(.top, 8)  // Align bullet with text center
            }
            
            // Render the list item content
            VStack(alignment: .leading, spacing: 0) {
                // Iterate through all block elements within the list item
                ForEach( Array(listItem.blockChildren.enumerated()),
                         id: \.offset) { idx, block in
                    
                    // Handle different types of content that can appear in list items
                    switch block {
                    case let paragraph as Paragraph:
                        // Regular text content with inline formatting
                        Text(getMarkdownText(from: paragraph))
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    case let nestedList as UnorderedList:
                        // Nested unordered list (recursive)
                        SMUnorderedList(nestedList, indentLevel: indentLevel + 1)
                    case let nestedOrderedList as OrderedList:
                        // Nested ordered list
                        SMOrderedList(nestedOrderedList, indentLevel: indentLevel + 1)
                    case let codeBlock as CodeBlock:
                        // Code blocks within list items
                        SMCodeNative(codeBlock)
                    default:
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
    ///
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

#Preview("Unordered Lists") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            SwiftMardownView(markdown: """
            - Simple list item one
            - Simple list item two
            - Simple list item three
            """)
            
            SwiftMardownView(markdown: """
            - List with **bold** text
            - List with *italic* text
            - List with `inline code`
            """)
            
            SwiftMardownView(markdown: """
            - Nested list example
                - Sub item one
                - Sub item two
                    - Deep nested item
                - Back to sub level
            - Back to main level
            """)
            
            SwiftMardownView(markdown: """
            ## Task Lists
            
            - [ ] Unchecked task item
            - [x] Checked task item
            - [ ] Another unchecked item
                - [x] Nested checked item
                - [ ] Nested unchecked item
            - Regular item without checkbox
            """)
            
            SwiftMardownView(markdown: """
            - Long list item that contains a lot of text and should wrap to multiple lines when displayed in the markdown renderer
            - Short item
            - Another long item with **bold text** and *italic text* that demonstrates how inline formatting works within list items
            """)
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}
