# MDView

A SwiftUI application that implements a custom markdown renderer using Apple's `swift-markdown` parser.

## Features

- **Custom Markdown Rendering**: Built from scratch using Apple's `swift-markdown` parser
- **Pure SwiftUI**: All components implemented using native SwiftUI views
- **Task Lists**: Support for GitHub-style task lists with checkboxes
- **Rich Text Support**: Full inline markdown formatting (bold, italic, links, etc.)
- **Cross-Platform**: Works on both macOS and iOS
- **Live Preview**: Side-by-side editor and preview with animated transitions
- **Debug View**: Inspect the parsed markdown structure
- **Minimal Dependencies**: Only uses essential Swift packages

## Components

### Markdown Elements Supported

- **Headings** (H1-H6) with proper sizing and styling
- **Paragraphs** with inline formatting
- **Code Blocks** with monospaced font and language labels
- **Blockquotes** with visual left border
- **Lists** (ordered, unordered, and task lists)
- **Tables** with borders and alignment
- **Images** with async loading via Kingfisher
- **Links** rendered with native Text view
- **Horizontal Rules**

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
        ├── SMUnorderedList.swift # Bullet and task lists
        ├── SMOrderedList.swift  # Numbered lists
        ├── SMTable.swift        # Table rendering
        └── SMImage.swift        # Async image loading
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
- **Editor/Debug Toggle**: Switch between markdown editor and parsed structure view
- **Preview Toggle**: Show/hide the rendered markdown preview
- **Animated Transitions**: Smooth animations when toggling panels

### Code Block Styling

Code blocks feature:
- Monospaced font for readability
- Language label display when specified
- Horizontal scrolling for long lines
- Adaptive background color for light/dark mode
- Text selection support

### List Handling

Advanced list features:
- Unlimited nesting depth
- Mixed list types (ordered within unordered, etc.)
- Task list checkboxes with SF Symbols
- Proper indentation and spacing
- Support for complex content within list items

### Text Formatting

Native SwiftUI Text view handles:
- **Bold** and *italic* text
- `Inline code` spans
- [Links](https://example.com)
- Combinations like ***bold italic***

## Implementation Details

### Pure SwiftUI Approach

All components are implemented using native SwiftUI views:
- No UIViewRepresentable/NSViewRepresentable
- No external syntax highlighting libraries
- Minimal external dependencies
- Clean, maintainable code

### Performance Optimizations

- Lazy loading of markdown blocks
- Efficient text rendering with AttributedString
- Minimal view rebuilds with proper state management
- Trimmed whitespace to fix list spacing issues

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

- Apple's [swift-markdown](https://github.com/apple/swift-markdown) for markdown parsing
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading