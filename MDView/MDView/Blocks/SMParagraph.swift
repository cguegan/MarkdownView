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


//#Preview {
//    SMParagraph()
//}

