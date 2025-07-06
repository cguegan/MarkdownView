# MDView

A SwiftUI application that implements a custom markdown renderer using Apple's `swift-markdown` parser. Built entirely with Claude Code as a learning exercise in pure SwiftUI development. Feel free to play, hack and use as you want.

## Features

- **Custom Markdown Rendering**: Built from scratch using Apple's `swift-markdown` parser
- **Pure SwiftUI**: All components implemented using native SwiftUI views without UIKit/AppKit bridges
- **Grid-based Tables**: Modern SwiftUI Grid API for proper table layout with dividers
- **Task Lists**: Support for GitHub-style task lists with interactive checkboxes
- **Rich Text Support**: Full inline markdown formatting (bold, italic, links, code, etc.)
- **Image Handling**: Async loading with error states, placeholders, and size constraints
- **Cross-Platform**: Works on iOS, macOS, and visionOS
- **Live Preview**: Side-by-side editor and preview with smooth animated transitions
- **Debug View**: Inspect the parsed markdown AST structure
- **Minimal Dependencies**: Only uses essential Swift packages (no syntax highlighting libraries)

## Components

### Markdown Elements Supported

- **Headings** (H1-H6) with proper sizing and semantic styling
- **Paragraphs** with full inline markdown formatting support
- **Code Blocks** with monospaced font, language labels, and adaptive colors
- **Blockquotes** with visual left border and nested content support
- **Lists** (ordered, unordered, and interactive task lists with checkboxes)
- **Tables** with Grid layout, black dividers, and inline markdown in cells
- **Images** with async loading, error handling, placeholders, and size constraints
- **Links** rendered as tappable native Text views
- **Horizontal Rules** (thematic breaks) supporting ---, ***, and ___ styles

### Architecture

```
MDView/
├── App/
│   └── MDViewApp.swift          # Main app entry point
├── Views/
│   ├── ContentView.swift        # Main UI with editor/preview panels
│   ├── EditorView.swift         # Markdown text editor
│   ├── DebugStructView.swift    # Debug tree view
│   └── MarkdownView.swift       # Third-party comparison view
└── MDView/
    ├── SwiftMardownView.swift   # Main renderer that parses and delegates
    └── Blocks/
        ├── SMHeading.swift      # Heading renderer (H1-H6)
        ├── SMParagraph.swift    # Paragraph with inline markdown
        ├── SMCode.swift         # Code blocks with clean styling
        ├── SMBlockquote.swift   # Blockquote with border styling
        ├── SMUnorderedList.swift  # Bullet and task lists
        ├── SMOrderedList.swift   # Numbered lists
        ├── SMTable.swift         # Table rendering
        ├── SMImage.swift         # Async image loading
        └── SMThematicBreak.swift # Horizontal rules
```

## Dependencies

- **[swift-markdown](https://github.com/apple/swift-markdown)**: Apple's CommonMark parser
- **[Kingfisher](https://github.com/onevcat/Kingfisher)**: Image loading and caching

## Usage

### Basic Implementation

```swift
import SwiftUI

struct ContentView: View {
    let markdown = """
    # Hello World

    This is a **bold** text with `inline code`.

    ```swift
    func greet() {
        print("Hello!")
    }
    ```
    """

    var body: some View {
        SwiftMardownView(markdown: markdown)
    }
}
```

### Task Lists

```markdown
- [ ] Unchecked task
- [x] Completed task
- Regular list item
```

### Code Blocks

````markdown
```swift
struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}
```

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```
````

### Nested Lists

```markdown
1. First item
   - Nested bullet
   - Another nested item
     1. Deep nested numbered
     2. Another deep item
2. Second item
   - [x] Nested task
   - [ ] Unchecked task
```

### Tables

```markdown
| Feature | Status | Priority |
|---------|--------|----------|
| **Bold text** | ✅ Complete | High |
| *Italic text* | ✅ Complete | Medium |
| `Code blocks` | 🔄 In Progress | High |
| [Links](https://example.com) | ⏳ Pending | Low |

| Name | Age | City |
|------|-----|------|
| John Doe | 30 | New York |
| Jane Smith | 25 | London |
```

### Images

```markdown
![Beautiful landscape](https://images.unsplash.com/photo-123456)

![Error handling demo](https://broken-url.com/image.jpg)

![Placeholder example](https://via.placeholder.com/300x200)
```

### Horizontal Rules

```markdown
Regular paragraph above.

---

New section with three hyphens.

***

Another section with three asterisks.

___

Final section with three underscores.
```

## Building

### Requirements

- Xcode 15.0+
- iOS 17.0+ / macOS 14.0+
- Swift 5.9+

### Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/cguegan/MarkdownView.git
   cd MarkdownView
   ```

2. Open in Xcode:
   ```bash
   open MDView.xcodeproj
   ```

3. Build and run (⌘R)

### Command Line Build

```bash
# Build
xcodebuild -project MDView.xcodeproj -scheme MDView -configuration Debug build

# Clean
xcodebuild -project MDView.xcodeproj clean
```

## Features in Detail

### View Modes

The app provides multiple viewing modes accessible via toolbar:
- **Editor/Debug Toggle**: Switch between markdown editor and parsed AST structure view
- **Preview Toggle**: Show/hide the rendered markdown preview with smooth animations
- **Split View**: Resizable panels for comfortable editing and preview

### Table Rendering

Tables are rendered using SwiftUI's Grid API:
- Automatic column sizing and alignment
- Black dividers between rows for clear separation
- Bold header row with thick bottom border
- Support for inline markdown formatting in cells
- Proper handling of tables with uneven row lengths
- Clean, native SwiftUI implementation

### Image Handling

Enhanced image support with:
- Asynchronous loading with Kingfisher
- Error state with customizable placeholder
- Loading progress indicators
- Maximum size constraints (600x400)
- Alt text display for accessibility
- Graceful handling of broken URLs

### Code Block Styling

Code blocks feature:
- Monospaced font for readability
- Language label display when specified
- Adaptive background color for light/dark mode
- Clean borders and padding
- Text selection support
- No external syntax highlighting dependencies

### List Handling

Advanced list features:
- Unlimited nesting depth
- Mixed list types (ordered within unordered, etc.)
- Interactive task list checkboxes with SF Symbols
- Proper indentation and spacing
- Support for complex content within list items
- Trimmed whitespace for consistent rendering

### Text Formatting

Native SwiftUI Text view with AttributedString handles:
- **Bold** and *italic* text
- `Inline code` spans with background
- [Tappable links](https://example.com)
- Combinations like ***bold italic***
- Proper markdown parsing in all contexts

## Implementation Details

### Pure SwiftUI Approach

All components are implemented using native SwiftUI views:
- No UIViewRepresentable/NSViewRepresentable wrappers
- No external syntax highlighting libraries (removed Highlightr)
- Grid API for modern table layout
- AttributedString for markdown text formatting
- Minimal external dependencies
- Clean, maintainable, idiomatic SwiftUI code

### Performance Optimizations

- Lazy loading of markdown blocks
- Efficient text rendering with AttributedString
- Minimal view rebuilds with proper state management
- Trimmed whitespace to fix list spacing issues
- Async image loading with caching via Kingfisher

### Recent Improvements

- **Grid-based Tables**: Migrated from HStack to Grid for proper table layout
- **Enhanced Images**: Added error handling, placeholders, and size constraints
- **Horizontal Rules**: Added support for thematic breaks (---, ***, ___)
- **Table Formatting**: Fixed inline markdown support in table cells
- **Pure SwiftUI**: Removed Highlightr dependency for simpler implementation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

- Apple's [swift-markdown](https://github.com/apple/swift-markdown) for markdown parsing
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading
