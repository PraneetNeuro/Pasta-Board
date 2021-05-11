//
//  ContentView.swift
//  Pasta Board
//
//  Created by Praneet S on 09/05/21.
//

import SwiftUI

struct ContentView: View {
    
    enum ExpandedState: Int {
        case urls
        case images
        case textSnippets
    }
    
    let timerPublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default).autoconnect()
    @ObservedObject var clipboardManager: ClipboardManager = ClipboardManager.shared
    @State var expandedState: ExpandedState = .urls
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: expandedState == .urls ? "chevron.down" : "chevron.right")
                    .padding(.horizontal)
                Text("URLs (\(clipboardManager.urls.count))")
                Spacer()
            }
            .modifier(EnableHeaderView())
            .onTapGesture {
                expandedState = .urls
            }
            if expandedState == .urls {
                List(Array(clipboardManager.urls), id: \.self) { url in
                    HStack {
                        Text(url.absoluteString)
                        Spacer()
                        Button(action: {
                            clipboardManager.setTextSnippet(url.absoluteString)
                        }, label: {
                            Text("Copy")
                        })
                    }
                }
                .listStyle(SidebarListStyle())
            }
            HStack {
                Image(systemName: expandedState == .textSnippets ? "chevron.down" : "chevron.right")
                    .padding(.horizontal)
                Text("Text snippets (\(clipboardManager.textSnippets.count))")
                Spacer()
            }
            .modifier(EnableHeaderView())
            .onTapGesture {
                expandedState = .textSnippets
            }
            if expandedState == .textSnippets {
                List(Array(clipboardManager.textSnippets), id: \.self) { textSnippet in
                    HStack {
                        Text(textSnippet)
                        Spacer()
                        Button(action: {
                            print(textSnippet)
                            clipboardManager.setTextSnippet(textSnippet)
                        }, label: {
                            Text("Copy")
                        })
                    }
                }
                .listStyle(SidebarListStyle())
            }
            HStack {
                Image(systemName: expandedState == .images ? "chevron.down" : "chevron.right")
                    .padding(.horizontal)
                Text("Images (\(clipboardManager.imageDataInClipboard.count))")
                Spacer()
            }
            .modifier(EnableHeaderView())
            .onTapGesture {
                expandedState = .images
            }
            if expandedState == .images {
                List(Array(clipboardManager.imageDataInClipboard), id: \.self) { imageData in
                    Image(nsImage: NSImage(data: imageData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(6)
                        .onTapGesture {
                            clipboardManager.setImageData(imageData)
                        }
                }
                .listStyle(SidebarListStyle())
            }
        }.onReceive(timerPublisher, perform: { _ in
            clipboardManager.refreshClipboard()
        })
        .frame(width: 400, height: 400, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct EnableHeaderView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(4)
            .background(Color.accentColor.opacity(0.4))
            .cornerRadius(6)
            .padding(4)
    }
}
