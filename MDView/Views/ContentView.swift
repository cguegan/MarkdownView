//
//  ContentView.swift
//  MDView
//
//  Created by Christophe Guégan on 05/07/2025.
//

import SwiftUI

enum LeftPanelMode: String, CaseIterable {
    case editor = "Editor"
    case debug = "Debug"
}

struct ContentView: View {
    
    /// State properties
    @State private var markdown: String = ""
    @State private var leftPanelMode: LeftPanelMode = .editor
    @State private var showPreview: Bool = true
    
    ///
    let filepath = Bundle.main.url(forResource: "test", withExtension: "md")

    
    /// Main View
    var body: some View {
        NavigationStack {
            // Main content area
            HStack(spacing: 0) {
                // Left panel
                Group {
                    switch leftPanelMode {
                    case .editor:
                        EditorView(markdownText: $markdown)
                    case .debug:
                        DebugStructView(markdown: markdown)
                    }
                }
                .frame(minWidth: 400)
                
                // Right panel with animation
                if showPreview {
                    Divider()
                    
                    SwiftMardownView(markdown: markdown)
                        .frame(minWidth: 400)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showPreview)
            .navigationTitle("Markdown View")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                toolbarContent
            }
        }
        .onAppear() {
            markdown = try! String(contentsOf: filepath!, encoding: .utf8)
        }
    }
}

// MARK: - Subviews
// ————————————————

extension ContentView {
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        
        /// Left picker to display editor or debug
        ///
        ToolbarItem(placement: .navigation) {
            
            Picker("Mode", selection: $leftPanelMode) {
                ForEach(LeftPanelMode.allCases, id: \.self) { mode in
                    Label {
                        Text(mode.rawValue)
                    } icon: {
                        Image(systemName: mode == .editor ? "square.and.pencil" : "doc.text.magnifyingglass")
                    }
                    .tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .frame(width: 120)
        }
        
        ToolbarItem(placement: .primaryAction) {
            // Preview toggle
            Toggle(isOn: $showPreview) {
                Label("Show Preview", systemImage: showPreview ? "sidebar.right" : "sidebar.right")
            }
            .toggleStyle(.button)
        }
    }
    
}

// MARK: - Previews
// ————————————————

#Preview {
    ContentView()
}
