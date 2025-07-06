//
//  SMHeadingView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SMHeading: View {

    let content: Heading
    let level: Int
    
    ///  Initialisation
    init(_ content: Heading, level: Int) {
        self.content = content
        self.level = level
    }
    
    /// Computed Properties
    var titleLevel: Font {
        switch level {
        case 1:
                .largeTitle
        case 2:
                .title
        case 3:
                .title2
        case 4:
                .title3
        case 5:
                .headline
        case 6:
                .subheadline
        default:
                .body
        }
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
        VStack(alignment: .leading, spacing: 0 ) {
            Text(markdownText)
                .font(titleLevel)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            
            Rectangle()
                .fill(Color.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .padding(.top, 4)
        }
        .padding(.horizontal)
    }
    
}

#Preview("Heading Levels") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(1...6, id: \.self) { level in
                SwiftMardownView(markdown: String(repeating: "#", count: level) + " Heading Level \(level)")
            }
            
            Divider()
            
            // Test with inline formatting
            SwiftMardownView(markdown: "## Heading with **bold** and *italic* text")
            SwiftMardownView(markdown: "### Heading with `inline code`")
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}
