//
//  EditorView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI

struct EditorView: View {
    
    @Binding var markdownText: String
    
    
    /// Main Body
    var body: some View {
        TextEditor(text: $markdownText)
            .padding()
            .frame(maxWidth: .infinity)
            .font(.system(.callout, design: .monospaced))
            .autocorrectionDisabled()    }
}

// MARK: - Previews
// ————————————————


