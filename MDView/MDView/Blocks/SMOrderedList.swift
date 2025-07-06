//
//  SMOrderedList.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SMOrderedList: View {
    
    /// Properties
    let content: OrderedList
    let indentLevel: Int
    
    /// Computed Properties
    var items: [ListItem] {
        return content.children.compactMap { $0 as? ListItem }
    }
    
    /// Initialiser
    init(_ list: OrderedList, indentLevel: Int = 0) {
        self.content = list
        self.indentLevel = indentLevel
    }
    
    /// Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items.indices, id: \.self) { idx in
                let item = items[idx]
                renderListItem(item, index: idx)
            }
        }
        .padding(.top, indentLevel == 0 ? 0 : 3)

    }
    
    func renderListItem(_ listItem: ListItem, index: Int) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(index + 1).")
                .font(.system(.body, design: .default))
                .frame(minWidth: 20, alignment: .trailing)
                .padding(.leading, 20)
            
            VStack(alignment: .leading, spacing: 0) {
                // Render all blocks within the list item
                ForEach(Array(listItem.blockChildren.enumerated()), id: \.offset) { idx, block in
                    if let paragraph = block as? Paragraph {
                        Text(getMarkdownText(from: paragraph))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(0)
                            .padding(.vertical, 0)
                    } else if let nestedList = block as? UnorderedList {
                        SMUnorderedList(nestedList, indentLevel: indentLevel + 1)
                    } else if let nestedOrderedList = block as? OrderedList {
                        SMOrderedList(nestedOrderedList, indentLevel: indentLevel + 1)
                    } else if let codeBlock = block as? CodeBlock {
                        SMCode(codeBlock)
                    } else {
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
