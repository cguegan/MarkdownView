//
//  SMImage.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI
import Markdown
import Kingfisher

struct SMImage: View {
    
    /// Given Property
    let content: Markdown.Image

    var url: URL {
        if let source = content.source,
           let url = URL(string: source) {
            return url
        } else {
            return URL(string: "https://picsum.photos/200/300")!
        }
    }
    
    ///  Initialisation
    init(_ content: Markdown.Image) {
        self.content = content
    }
    
    /// Main Body
    var body: some View {
        VStack {
            KFImage(url)
                .placeholder {
                    ProgressView()
                }
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}


// MARK: - Subviews
// ————————————————

#Preview("Images") {
    ScrollView {
        VStack(alignment: .leading, spacing: 30) {
            Text("Remote Images")
                .font(.headline)
            
            SwiftMardownView(markdown: """
            ![Beautiful landscape](https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&auto=format&fit=crop&q=80)
            """)
            
            SwiftMardownView(markdown: """
            ![Small image](https://via.placeholder.com/200x150)
            """)
            
            Text("Image with caption")
                .font(.headline)
                .padding(.top)
            
            SwiftMardownView(markdown: """
            ![Mountain view](https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=600&auto=format&fit=crop&q=80)
            
            *Figure 1: A beautiful mountain landscape at sunset*
            """)
            
            Text("Multiple images")
                .font(.headline)
                .padding(.top)
            
            SwiftMardownView(markdown: """
            Here are some images in a paragraph:
            
            ![First](https://via.placeholder.com/300x200/FF0000/FFFFFF?text=First)
            
            ![Second](https://via.placeholder.com/300x200/00FF00/FFFFFF?text=Second)
            
            ![Third](https://via.placeholder.com/300x200/0000FF/FFFFFF?text=Third)
            """)
        }
        .padding()
    }
    .frame(maxWidth: .infinity)
}

