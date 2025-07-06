//
//  SwiftMardownView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SwiftMardownView: View {
    
    var markdown: String = ""
    
    private var parsed: Document {
        Document(parsing: markdown)
    }
    
    var body: some View {
        ScrollView { 
            VStack(alignment: .leading, spacing: 12) {
                result
            }
        }
        .frame( maxWidth: .infinity, maxHeight: .infinity )
    }
    
    /// Buid result
    ///
    @ViewBuilder
    private var result: some View {
        ForEach(Array(parsed.children.enumerated()), id: \.offset) { idx, item in
            switch item {
            case let heading as Heading:
                SMHeading(heading, level: heading.level)
            case let unorderedList as UnorderedList:
                SMUnorderedList(unorderedList)
            case let orderedList as OrderedList:
                SMOrderedList(orderedList)
            case let blockQuote as BlockQuote:
                SMBlockquote(blockQuote)
            case let table as Markdown.Table:
                SMTable(table)
            case let codeBlock as CodeBlock:
                SMCodeSyntax(codeBlock)
            case let paragraph as Paragraph:
                // Check if the paragraph contains Markdown.Image children
                let images = paragraph.children.compactMap { $0 as? Markdown.Image }
                if !images.isEmpty {
                    ForEach(Array(images.enumerated()), id: \.offset) { idx, image in
                        SMImage(image)
                    }
                } else {
                    SMParagraph(paragraph)
                }
            default:
                Text("WIP")
            }
        }
    }
    

}


#Preview {
    SwiftMardownView()
}
