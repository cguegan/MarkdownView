# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS SwiftUI project called MDView that implements and compares different approaches to rendering Markdown in SwiftUI.

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
│   ├── ContentView.swift          # Main comparison view
│   ├── EditorView.swift          # Text editor component
│   ├── AppleMarkdownView.swift   # Apple's implementation (if applicable)
│   └── MarkdownStyledView.swift  # Alternative markdown styling implementation
├── MDView/
│   ├── SwiftMardownView.swift    # Custom markdown renderer
│   └── Blocks/                   # Custom SwiftUI components for each markdown element
│       ├── SMHeading.swift
│       ├── SMParagraph.swift
│       ├── SMCode.swift
│       ├── SMBlockquote.swift
│       ├── SMUnorderedList.swift
│       ├── SMOrderedList.swift
│       ├── SMTable.swift
│       └── SMImage.swift
├── Assets.xcassets/              # Asset catalog
└── PreviewAssets/
    └── test.md                   # Sample markdown for testing
```

### Core Components

1. **Two Markdown Rendering Approaches**:
   - **SwiftMardownView**: Custom implementation using Apple's swift-markdown parser
   - **AppleMarkdownView**: Apple's implementation (if applicable)

2. **SwiftMarkdown Custom Implementation Structure**:
   ```
   MDView/SwiftMardownView.swift
   └── Parses markdown using swift-markdown Document
   └── Maps each block type to custom SwiftUI components:
       ├── SMHeading
       ├── SMParagraph
       ├── SMCode (with syntax highlighting via Highlightr)
       ├── SMBlockquote
       ├── SMUnorderedList
       ├── SMOrderedList
       ├── SMTable
       └── SMImage (with async loading via Kingfisher)
   ```

3. **Main View Structure**:
   - `ContentView`: Main container with flexible layout:
     - **Left Panel**: Toggle between Editor or Debug view using segmented control
     - **Right Panel**: Markdown preview that can be shown/hidden with animated transition
     - Control bar includes:
       - Segmented picker for left panel mode (Editor/Debug)
       - Toggle switch for showing/hiding the preview panel
   - **Animation**: Right panel slides in/out with opacity transition (0.3s ease-in-out)
   - `EditorView`: Text editor component with two-way binding to markdown text
   - `DebugStructView`: Shows parsed markdown AST structure
   - `SwiftMardownView`: Renders the markdown content in the preview panel

### Key Dependencies

- **swift-markdown**: Apple's CommonMark parser
- **Kingfisher**: Image loading and caching
- **Highlightr**: Code syntax highlighting
- **LaTeXSwiftUI** & **MathJaxSwift**: Math rendering (imported but not yet implemented)

### Important Implementation Details

- Custom block components handle their own styling and layout
- Image handling extracts images from paragraphs for proper rendering
- Code blocks support language-specific syntax highlighting
- Tables are rendered with proper cell alignment and borders
- Lists support nested structures

### Test Data

The project uses `test.md` as sample markdown content located in `PreviewAssets/` and loaded via Bundle resources in ContentView.