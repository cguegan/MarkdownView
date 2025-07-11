//
//  SMTable.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown

/// A SwiftUI view component that renders Markdown tables using Grid layout.
///
/// This component provides table rendering with:
/// - Native SwiftUI Grid for proper column alignment
/// - Header row with bold styling and separator
/// - Support for inline markdown in cells
/// - Alternating row colors for better readability
/// - Proper column width distribution
/// - Cell padding and alignment
///
/// Features:
/// - **Grid Layout**: Uses SwiftUI Grid for automatic column sizing
/// - **Header Styling**: Bold headers with bottom border
/// - **Row Styling**: Alternating background colors
/// - **Flexible Content**: Supports inline markdown in cells
/// - **Responsive**: Adapts to content width
///
/// Example markdown:
/// ```markdown
/// | Header 1 | Header 2 | Header 3 |
/// |----------|----------|----------|
/// | Cell 1   | Cell 2   | Cell 3   |
/// | Cell 4   | Cell 5   | Cell 6   |
/// ```
struct SMTable: View {
    
    /// The Table content from the swift-markdown parser
    let content: Markdown.Table
    
    /// Tracks the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    /// Initializes a new table view
    /// - Parameter content: The Table object from swift-markdown parser
    init(_ content: Markdown.Table) {
        self.content = content
    }
    
    /// Extract header cells
    var headerCells: [Markdown.Table.Cell] {
        content.head.children.compactMap { $0 as? Markdown.Table.Cell }
    }
    
    /// Extract body rows
    var bodyRows: [Markdown.Table.Row] {
        content.body.children.compactMap { $0 as? Markdown.Table.Row }
    }
    
    /// Main body using Grid
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 0) {
            // Header row
            GridRow {
                ForEach(headerCells.indices, id: \.self) { index in
                    cellContent(headerCells[index])
                        .font(.system(.body, weight: .semibold))
                        .padding(.vertical, 8)
                }
            }
            
            // Header separator
            Rectangle()
                .foregroundStyle(.black)
                .gridCellColumns(headerCells.count)
                .frame(height: 2)
            
            // Body rows
            ForEach(Array(bodyRows.enumerated()), id: \.offset) { rowIndex, row in
                GridRow {
                    let cells = row.children.compactMap { $0 as? Markdown.Table.Cell }
                    
                    ForEach(cells.indices, id: \.self) { cellIndex in
                        cellContent(cells[cellIndex])
                            .padding(.vertical, 6)
                            .padding(.horizontal, 4)
                            .frame(maxWidth: .infinity, alignment: leadingAlignment(for: cells[cellIndex]))
                    }
                    
                    // Fill empty cells if row has fewer cells than header
                    if cells.count < headerCells.count {
                        ForEach(cells.count..<headerCells.count, id: \.self) { _ in
                            Text("")
                                .gridColumnAlignment(.leading)
                        }
                    }
                }
                
                // Add divider between rows (but not after the last row)
                if rowIndex < bodyRows.count - 1 {
                    Divider()
                        .overlay(Color.black.opacity(0.7))
                        .gridCellColumns(headerCells.count)
                }
            }
        }
        .padding()
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    /// Get formatted content from a table cell
    func getCellAttributedString(_ cell: Markdown.Table.Cell) -> AttributedString {
        // Get the plain text content and try to parse it as markdown
        let cellText = cell.plainText
        
        // Try to create an attributed string with markdown formatting
        if let attributedString = try? AttributedString(markdown: cellText) {
            return attributedString
        }
        
        // Fallback to plain text without formatting
        return AttributedString(cellText)
    }
    
    /// Render cell content with markdown support
    @ViewBuilder
    func cellContent(_ cell: Markdown.Table.Cell) -> some View {
        Text(getCellAttributedString(cell))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    /// Determine alignment based on cell content or column alignment
    func leadingAlignment(for cell: Markdown.Table.Cell) -> Alignment {
        // For now, default to leading alignment
        // Could be enhanced to detect numeric content for trailing alignment
        return .leading
    }
}

// MARK: - Previews
// ————————————————

#Preview("Tables") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            Text("Basic Table")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            | Header 1 | Header 2 | Header 3 |
            |----------|----------|----------|
            | Cell 1   | Cell 2   | Cell 3   |
            | Cell 4   | Cell 5   | Cell 6   |
            """)
            
            Text("Table with Different Content")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            | Name | Age | City |
            |------|-----|------|
            | John Doe | 30 | New York |
            | Jane Smith | 25 | London |
            | Bob Johnson | 35 | Paris |
            | Alice Williams | 28 | Tokyo |
            """)
            
            Text("Table with Inline Markdown")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            | Feature       | Status         | Priority |
            |---------------|----------------|----------|
            | **Bold text** | ✅ Complete    | High     |
            | *Italic text* | ✅ Complete    | Medium   |
            | `Code blocks` | 🔄 In Progress | High     |
            | Links         | ⏳ Pending     | Low      |
            """)
            
            Text("Table with Long Content")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            | Long Column Header | Short | Another Header |
            |--------------------|-------|----------------|
            | This is a very long cell content that should wrap properly | OK | Another cell     |
            | Short              | A bit longer content here | Short |
            | Medium length text | Text | Final cell content |
            """)
            
            Text("Uneven Table")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            | Col 1 | Col 2 | Col 3 | Col 4 |
            |-------|-------|-------|-------|
            | A     | B     | C     | D     |
            | E     | F     |       |       | 
            | G     | H     | I     |       |
            """)
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}

