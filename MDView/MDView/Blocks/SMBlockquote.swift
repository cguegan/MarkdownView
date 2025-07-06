//
//  SMBlockquote.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SMBlockquote: View {

    let content: BlockQuote
    
    ///  Initialisation
    init(_ content: BlockQuote) {
        self.content = content
    }
    
    /// Main Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(content.blockChildren.enumerated()), id: \.offset) { _, block in
                if let paragraph = block as? Paragraph {
                    Text(getMarkdownText(from: paragraph))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else if let heading = block as? Heading {
                    SMHeading(heading, level: heading.level)
                } else if let list = block as? UnorderedList {
                    SMUnorderedList(list)
                } else if let orderedList = block as? OrderedList {
                    SMOrderedList(orderedList)
                } else if let nestedQuote = block as? BlockQuote {
                    SMBlockquote(nestedQuote)
                } else if let codeBlock = block as? CodeBlock {
                    SMCode(codeBlock)
                } else {
                    // Fallback for other block types
                    Text(block.format())
                }
            }
        }
        .lineSpacing(4)
        .padding(.leading, 18)
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
        .overlay() {
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
    
    /// Helper function to get markdown text as AttributedString
    private func getMarkdownText(from paragraph: Paragraph) -> AttributedString {
        do {
            let markdownString = paragraph.format()
            return try AttributedString(markdown: markdownString)
        } catch {
            return AttributedString(paragraph.plainText)
        }
    }
    
}

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
