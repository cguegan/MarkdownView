# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS/macOS SwiftUI project called MDView that implements a pure SwiftUI markdown renderer using Apple's swift-markdown parser.

## Build and Development Commands

This is an Xcode project. Use the following commands and workflows:

### Building
- Open `MDView.xcodeproj` in Xcode
- Build: `Cmd+B` or Product → Build
- Run: `Cmd+R` or Product → Run
- Clean: `Cmd+Shift+K` or Product → Clean Build Folder

### Command Line (alternative)
```bash
# Build from command line
xcodebuild -project MDView.xcodeproj -scheme MDView -configuration Debug build

# Clean
xcodebuild -project MDView.xcodeproj clean
```

## Architecture

### Project Structure

```
MDView/
├── App/
│   └── MDViewApp.swift            # Main app entry point
├── Views/
│   ├── ContentView.swift          # Main UI with editor/preview panels
│   ├── EditorView.swift          # Markdown text editor
│   ├── DebugStructView.swift     # Debug tree view of parsed markdown
│   └── MarkdownView.swift        # Third-party comparison view
├── MDView/
│   ├── SwiftMardownView.swift    # Main renderer that parses and delegates
│   └── Blocks/                   # Custom SwiftUI components for each element
│       ├── SMHeading.swift       # H1-H6 headers
│       ├── SMParagraph.swift     # Text with inline formatting
│       ├── SMCode.swift          # Code blocks with monospace font
│       ├── SMBlockquote.swift    # Quoted text with border
│       ├── SMUnorderedList.swift # Bullet and task lists
│       ├── SMOrderedList.swift   # Numbered lists
│       ├── SMTable.swift         # Tables using SwiftUI Grid
│       ├── SMImage.swift         # Images with error handling
│       └── SMThematicBreak.swift # Horizontal rules (---)
├── Assets.xcassets/              # Asset catalog
└── PreviewAssets/
    └── test.md                   # Sample markdown for testing
```

### Core Components

1. **SwiftMarkdown Implementation**:
   - Uses Apple's swift-markdown parser for CommonMark compliance
   - Each markdown element type is mapped to a custom SwiftUI view
   - Pure SwiftUI implementation without UIKit/AppKit dependencies

2. **Key Features Implemented**:
   - **Headings**: Six levels with appropriate sizing
   - **Paragraphs**: With inline bold, italic, code, and links
   - **Lists**: Ordered, unordered, and task lists with nesting
   - **Code Blocks**: Monospaced font with language labels
   - **Tables**: Using SwiftUI Grid with dividers and inline formatting
   - **Images**: Async loading with error/loading states
   - **Blockquotes**: Visual left border styling
   - **Horizontal Rules**: Clean divider implementation

3. **Main View Structure**:
   - **ContentView**: Main container with flexible layout
     - Left Panel: Toggle between Editor or Debug view
     - Right Panel: Preview with show/hide animation
     - Toolbar controls for panel management
   - **EditorView**: Text editor with markdown syntax
   - **DebugStructView**: Shows parsed AST structure
   - **SwiftMardownView**: Renders the markdown content

### Key Dependencies

- **swift-markdown**: Apple's CommonMark parser
- **Kingfisher**: Image loading and caching

### Important Implementation Details

- All components use native SwiftUI views (no NSViewRepresentable/UIViewRepresentable)
- Inline markdown formatting uses AttributedString
- List spacing issues solved by trimming whitespace
- Table cells support inline markdown (bold, italic, code)
- Images have size constraints (max 600x400)
- Task lists use SF Symbols for checkboxes
- Horizontal rules are implemented as SMThematicBreak

### Recent Improvements

- Simplified SMCode to pure SwiftUI (removed Highlightr dependency)
- Refactored SMTable to use Grid API with row dividers
- Enhanced SMImage with error handling and placeholders
- Added SMThematicBreak for horizontal rules
- Fixed nested list spacing with content trimming

### Test Data

The project uses `test.md` in PreviewAssets/ as comprehensive sample content covering all supported markdown features.