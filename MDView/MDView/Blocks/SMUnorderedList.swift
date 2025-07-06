//
//  SMUnorderedListView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SMUnorderedList: View {
    
    /// Properties
    let content: UnorderedList
    let indentLevel: Int
    
    /// Computed Properties
    var items: [ListItem] {
        return content.children.compactMap { $0 as? ListItem }
    }
    
    /// Initialiser
    init(_ list: UnorderedList, indentLevel: Int = 0) {
        self.content = list
        self.indentLevel = indentLevel
    }
    
    /// Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items.indices, id: \.self) { idx in
                let item = items[idx]
                renderListItem(item)
            }
        }
        .padding(.top, indentLevel == 0 ? 0 : 3)

    }
    
    func renderListItem(_ listItem: ListItem) -> some View {
        HStack(alignment: .top, spacing: 8) {
            /// Display SF Symbols
            if let checkbox = listItem.checkbox {
                /// Task list item
                Image(systemName: checkbox == .checked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 16))
                    .foregroundColor(checkbox == .checked ? .accentColor : .secondary)
                    .padding(.leading, CGFloat(16 + (indentLevel * 24)))
                    .padding(.top, 2) // Align with text baseline
            } else {
                /// Bulleted list
                Image(systemName: "circle.fill")
                    .font(.system(size: 6))
                    .padding(.leading, CGFloat(16 + (indentLevel * 24)))
                    .padding(.top, 8) // Align bullet with text
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // Render all blocks within the list item
                ForEach( Array(listItem.blockChildren.enumerated()),
                         id: \.offset) { idx, block in
                    
                    switch block {
                    case let paragraph as Paragraph:
                        Text(getMarkdownText(from: paragraph))
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    case let nestedList as UnorderedList:
                        SMUnorderedList(nestedList, indentLevel: indentLevel + 1)
                    case let nestedOrderedList as OrderedList:
                        SMOrderedList(nestedOrderedList, indentLevel: indentLevel + 1)
                    case let codeBlock as CodeBlock:
                        SMCode(codeBlock)
                    default:
                        // Fallback for other block types
                        Text(block.format())
                    }
                }
            }
        }
    }
    
    /// Helper function to get markdown text as AttributedString
    private func getMarkdownText(from paragraph: Paragraph) -> AttributedString {
        do {
            let markdownString = paragraph.format()
            let trimmedMarkdownString = markdownString.trimmingCharacters(in: .whitespacesAndNewlines)
            return try AttributedString(markdown: trimmedMarkdownString)
        } catch {
            return AttributedString(paragraph.plainText)
        }
    }
     
    
}

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
