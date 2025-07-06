//
//  SMImage.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown
import Kingfisher

/// A SwiftUI view component that renders Markdown images with enhanced features.
///
/// This component provides comprehensive image display with:
/// - Async image loading with Kingfisher
/// - Loading state with progress indicator
/// - Error handling with fallback placeholder
/// - Size constraints to prevent oversized images
/// - Aspect ratio preservation
/// - Alt text display for accessibility
/// - Adaptive sizing based on image dimensions
///
/// Features:
/// - **Loading States**: Shows progress indicator while loading
/// - **Error Handling**: Displays placeholder image on load failure
/// - **Size Constraints**: Maximum width/height limits
/// - **Accessibility**: Shows alt text when available
/// - **Performance**: Image caching via Kingfisher
///
/// Example markdown:
/// ```markdown
/// ![Alt text](https://example.com/image.jpg)
/// 
/// ![](https://example.com/another.jpg)
/// ```
struct SMImage: View {
    
    /// The Image content from the swift-markdown parser
    let content: Markdown.Image
    
    /// Maximum width for images (prevents overflow)
    let maxWidth: CGFloat = 600
    
    /// Maximum height for images (prevents excessive scrolling)
    let maxHeight: CGFloat = 400
    
    /// Tracks the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
    /// State for tracking load errors
    @State private var hasError = false
    
    /// State for tracking image size
    @State private var imageSize: CGSize = .zero
    
    /// Computed URL from the image source
    var url: URL? {
        guard let source = content.source else { return nil }
        return URL(string: source)
    }
    
    /// Alt text for accessibility
    var altText: String? {
        if let title = content.title {
            return title
        } else if !content.plainText.isEmpty {
            return content.plainText
        }
        return nil
    }
    
    /// Initializes a new image view
    /// - Parameter content: The Image object from swift-markdown parser
    init(_ content: Markdown.Image) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if let url = url {
                // Remote image with Kingfisher
                KFImage(url)
                    .placeholder {
                        // Loading placeholder
                        loadingPlaceholder
                    }
                    .onFailure { error in
                        // Track error state
                        hasError = true
                    }
                    .onSuccess { result in
                        // Store image size for aspect ratio calculations
                        imageSize = result.image.size
                        hasError = false
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                    .cornerRadius(8)
                    .overlay(
                        // Error overlay
                        hasError ? errorOverlay : nil
                    )
            } else {
                // No URL provided - show error placeholder
                errorPlaceholder
            }
            
            // Alt text caption if available
            if let altText = altText, !altText.isEmpty {
                Text(altText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    /// Loading state placeholder
    @ViewBuilder
    private var loadingPlaceholder: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.2)
            
            Text("Loading image...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 200, height: 150)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
    
    /// Error state placeholder
    @ViewBuilder
    private var errorPlaceholder: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.fill")
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text("Image unavailable")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if let source = content.source {
                Text(source)
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                    .lineLimit(2)
                    .truncationMode(.middle)
                    .padding(.horizontal)
            }
        }
        .frame(width: 300, height: 200)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
    
    /// Error overlay for failed images
    @ViewBuilder
    private var errorOverlay: some View {
        ZStack {
            Color.black.opacity(0.6)
            
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                
                Text("Failed to load")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
        .cornerRadius(8)
    }
}

// MARK: - Previews
// ————————————————

#Preview("Images") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            Text("Working Images")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            ![Beautiful landscape](https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&auto=format&fit=crop&q=80)
            """)
            
            SwiftMardownView(markdown: """
            ![Small placeholder image with descriptive alt text](https://via.placeholder.com/200x150)
            """)
            
            Text("Large Image (constrained)")
                .font(.headline)
                .padding(.top)
            
            SwiftMardownView(markdown: """
            ![Very large image that will be constrained](https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=2000&auto=format&fit=crop&q=80)
            
            *This image is constrained to max width/height*
            """)
            
            Text("Error Cases")
                .font(.headline)
                .padding(.top)
            
            SwiftMardownView(markdown: """
            ![Broken URL image](https://this-domain-does-not-exist-123456.com/image.jpg)
            """)
            
            SwiftMardownView(markdown: """
            ![Image with no URL]()
            """)
            
            SwiftMardownView(markdown: """
            ![](https://httpstat.us/404)
            """)
            
            Text("Multiple Images")
                .font(.headline)
                .padding(.top)
            
            SwiftMardownView(markdown: """
            Here are some images in sequence:
            
            ![Red square](https://via.placeholder.com/300x200/FF0000/FFFFFF?text=Red)
            
            ![Green square](https://via.placeholder.com/300x200/00FF00/000000?text=Green)
            
            ![Blue square](https://via.placeholder.com/300x200/0000FF/FFFFFF?text=Blue)
            """)
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}