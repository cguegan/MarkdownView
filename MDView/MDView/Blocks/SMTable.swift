//
//  SMTable.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

struct SMTable: View {
    
    let content: Markdown.Table
    
    ///  Initialisation
    init(_ content: Markdown.Table) {
        self.content = content
    }
    
    /// Main Body
    var body: some View {
        VStack {
            header(content.head)
            rows(content.body)
        }
        .padding(.vertical, 6)
        .padding(.horizontal)
    }
    
    func header(_ header: Markdown.Table.Head) -> some View {
        let cells = header.children.compactMap { $0 as? Markdown.Table.Cell }
        return HStack {
            ForEach(cells.indices, id: \.self) { (index: Int) in
                let cell = cells[index]
                Text(cell.plainText)
                    .padding(.bottom, 5)
                    .frame(height: 20, alignment: .bottom)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .offset(y: 5)
        }
    }
    
    func rows(_ body: Markdown.Table.Body) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(body.children.enumerated()), id: \.offset) { (rowIndex, rowElement) in
                if let row = rowElement as? Markdown.Table.Row {
                    let cells = row.children.compactMap { $0 as? Markdown.Table.Cell }
                    HStack {
                        ForEach(cells.indices, id: \.self) { cellIndex in
                            Text(cells[cellIndex].plainText)
                                .padding(.bottom, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(height: 30, alignment: .center)
                }
                Divider()
            }
        }
    }
}


#Preview("Tables") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            SwiftMardownView(markdown: """
            | Header 1 | Header 2 | Header 3 |
            |----------|----------|----------|
            | Cell 1   | Cell 2   | Cell 3   |
            | Cell 4   | Cell 5   | Cell 6   |
            """)
            
            SwiftMardownView(markdown: """
            | Name | Age | City |
            |------|-----|------|
            | John Doe | 30 | New York |
            | Jane Smith | 25 | London |
            | Bob Johnson | 35 | Paris |
            """)
            
            SwiftMardownView(markdown: """
            | Feature | Status | Priority |
            |---------|--------|----------|
            | **Bold text** | ✅ Complete | High |
            | *Italic text* | ✅ Complete | Medium |
            | `Code blocks` | 🔄 In Progress | High |
            | ~~Strikethrough~~ | ❌ Not Started | Low |
            """)
            
            SwiftMardownView(markdown: """
            | Long Column Header That Should Wrap | Short | Another Long Header |
            |-------------------------------------|-------|---------------------|
            | This is a very long cell content that demonstrates how tables handle longer text | OK | Another long cell with lots of content |
            | Short | Short | Short |
            """)
        }
        .padding()
    }
    .frame(width: 700, height: 600)
}
