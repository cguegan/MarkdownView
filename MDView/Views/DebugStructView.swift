//
//  MarkdownStructView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct DebugStructView: View {
    
    var markdown: String = ""
    
    private var parsed: Document {
        Document(parsing: markdown)
    }
    
    private var debugDescription: String {
        parsed.debugDescription()
    }
    
    /// Main Body
    var body: some View {
        ScrollView {
            Text(debugDescription)
                .padding()
                .font(.system( size: 12,
                               weight: .regular,
                               design: .monospaced ))
        }
            
    }
}


// MARK: - Previews
// ————————————————

#Preview {
    DebugStructView(markdown: "Test")
        .frame(width: 300, height: 300)
}
