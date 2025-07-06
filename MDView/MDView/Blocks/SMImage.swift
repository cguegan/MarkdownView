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

//#Preview {
//    SMImage()
//}

