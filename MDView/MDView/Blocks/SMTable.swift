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


//#Preview {
//    SMParagraph()
//}
