# MDView

A SwiftUI application that implements a custom markdown renderer using Apple's `swift-markdown` parser with syntax highlighting support.

## Features

- **Custom Markdown Rendering**: Built from scratch using Apple's `swift-markdown` parser
- **Syntax Highlighting**: Code blocks with language-specific syntax highlighting via Highlightr
- **Task Lists**: Support for GitHub-style task lists with checkboxes
- **Rich Text Support**: Full inline markdown formatting (bold, italic, links, etc.)
- **Cross-Platform**: Works on both macOS and iOS
- **Live Preview**: Side-by-side editor and preview with animated transitions
- **Debug View**: Inspect the parsed markdown structure

## Components

### Markdown Elements Supported

- **Headings** (H1-H6)
- **Paragraphs** with inline formatting
- **Code Blocks** with syntax highlighting
- **Blockquotes**
- **Lists** (ordered, unordered, and task lists)
- **Tables**
- **Images** with async loading
- **Links**
- **Horizontal Rules**

### Architecture

```
MDView/
├── SwiftMardownView.swift    # Main renderer that parses and delegates to components
└── Blocks/
    ├── SMHeading.swift       # Heading renderer (H1-H6)
    ├── SMParagraph.swift     # Paragraph with inline markdown
    ├── SMCode.swift          # Code blocks with syntax highlighting
    ├── SMBlockquote.swift    # Blockquote styling
    ├── SMUnorderedList.swift # Bullet and task lists
    ├── SMOrderedList.swift   # Numbered lists
    ├── SMTable.swift         # Table rendering
    └── SMImage.swift         # Async image loading
```

## Dependencies

- **swift-markdown**: Apple's CommonMark parser
- **Highlightr**: Syntax highlighting for code blocks
- **Kingfisher**: Image loading and caching

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

### Code Blocks with Syntax Highlighting

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

### Editor Modes

The app provides multiple viewing modes:
- **Editor Only**: Full-screen markdown editor
- **Editor + Preview**: Side-by-side editing and preview
- **Debug + Preview**: View parsed structure alongside rendered output
- **Preview Only**: Full-screen rendered markdown

### Syntax Highlighting Themes

The code highlighting supports multiple themes:
- GitHub (light mode)
- Monokai (dark mode)
- Xcode
- Atom One Light

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

- Apple's [swift-markdown](https://github.com/apple/swift-markdown) for markdown parsing
- [Highlightr](https://github.com/raspu/Highlightr) for syntax highlighting
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading