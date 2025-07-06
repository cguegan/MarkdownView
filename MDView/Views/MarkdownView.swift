//
//  MarkdownView.swift
//  MDView
//
//  Created by Christophe Guégan on 06/07/2025.
//

import SwiftUI

struct MarkdownView: View {
    
    /// Given Property
    var markdown: String = ""

    /// Main Body
    var body: some View {
        SwiftMardownView(markdown: markdown)
    }
}


// MARK: - Previews
// ————————————————

#Preview {
    MarkdownView()
}
