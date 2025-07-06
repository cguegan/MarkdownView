//
//  SMParagraph.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SMParagraph: View {
    
    let content: Paragraph
    
    ///  Initialisation
    init(_ content: Paragraph) {
        self.content = content
    }
    
    /// Get the markdown text as AttributedString
    var markdownText: AttributedString {
        do {
            // Use the format() method to get markdown string
            let markdownString = content.format()
            return try AttributedString(markdown: markdownString)
        } catch {
            // Fallback to plain text if markdown parsing fails
            return AttributedString(content.plainText)
        }
    }
    
    /// Main Body
    var body: some View {
        Text(markdownText)
            .lineSpacing(4)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
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

