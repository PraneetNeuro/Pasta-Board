//
//  ClipboardManager.swift
//  Pasta Board
//
//  Created by Praneet S on 09/05/21.
//

import Foundation
import AppKit

class ClipboardManager: ObservableObject {
    private init() {}
    public static var shared: ClipboardManager = ClipboardManager()
    @Published var urls: Set<URL> = []
    @Published var textSnippets: Set<String> = []
    @Published var imageDataInClipboard: Set<Data> = []
    
    func setImageData(_ imageData: Data) {
        NSPasteboard.general.setData(imageData, forType: .png)
        NSPasteboard.general.setData(imageData, forType: .tiff)
    }
    
    func setTextSnippet(_ textSnippet: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textSnippet, forType: .string)
    }
    
    func refreshURLs() {
        let clipboardStringData = NSPasteboard.general.string(forType: .string)
        guard let nonEmptyString = clipboardStringData else {
            return
        }
        guard nonEmptyString.isValidURL else {
            textSnippets.insert(nonEmptyString)
            return
        }
        urls.insert(URL(string: nonEmptyString)!)
    }
    
    func refreshImages() {
        let pngDataInClipboard = NSPasteboard.general.data(forType: .png)
        let tiffDataInClipboard = NSPasteboard.general.data(forType: .tiff)
        guard let nonEmptyPNGData = pngDataInClipboard else {
            guard let nonEmptyTiffData = tiffDataInClipboard else {
                return
            }
            imageDataInClipboard.insert(nonEmptyTiffData)
            return
        }
        imageDataInClipboard.insert(nonEmptyPNGData)
    }
    
    func refreshClipboard() {
        refreshURLs()
        refreshImages()
    }
    
}
