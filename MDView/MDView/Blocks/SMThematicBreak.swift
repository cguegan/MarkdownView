//
//  SMThematicBreak.swift
//  MDView
//
//  Created by Christophe Guégan on 06/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown thematic breaks (horizontal rules).
///
/// This component provides a visual separator with:
/// - Clean horizontal line styling
/// - Adaptive color for light/dark mode
/// - Proper spacing above and below
/// - Consistent appearance across platforms
///
/// Example markdown:
/// ```markdown
/// Some content above
/// 
/// ---
/// 
/// Some content below
/// 
/// ***
/// 
/// Another section
/// ```
struct SMThematicBreak: View {
    
    /// The ThematicBreak content from the swift-markdown parser
    let content: ThematicBreak
    
    /// Tracks the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    /// Initializes a new thematic break view
    /// - Parameter content: The ThematicBreak object from swift-markdown parser
    init(_ content: ThematicBreak) {
        self.content = content
    }
    
    var body: some View {
        Divider()
            .frame(height: 1)
            .overlay(
                Color.secondary.opacity(0.3)
            )
            .padding(.vertical, 16)
            .padding(.horizontal)
    }
}

// MARK: - Previews
// ————————————————

#Preview("Thematic Breaks") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            SwiftMardownView(markdown: """
            # Section One
            
            Some content in the first section.
            
            ---
            
            # Section Two
            
            Content in the second section.
            """)
            
            SwiftMardownView(markdown: """
            Different styles of horizontal rules:
            
            Three hyphens:
            ---
            
            Three asterisks:
            ***
            
            Three underscores:
            ___
            
            With spaces:
            - - -
            
            * * *
            
            _ _ _
            """)
            
            SwiftMardownView(markdown: """
            Horizontal rules can separate major sections:
            
            ## Introduction
            
            This is the introduction paragraph with some content.
            
            ---
            
            ## Main Content
            
            This is the main content section.
            
            ---
            
            ## Conclusion
            
            This is the conclusion.
            """)
        }
        .padding()
    }
}