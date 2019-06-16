//
//  DownloadableFile.swift
//  SwiftUIDownloadViewDemo
//
//  Created by Nishith on 16/06/2019.
//  Copyright © 2019 Nishith. All rights reserved.
//

import Combine
import SwiftUI

class DownloadableFile: Hashable, Identifiable, Equatable {
    var id: String
    var title: String
    var progress: Float
    var isDownloading: Bool = true
    var downloadTimer: Timer?
    
    init(id: String, title: String, progress: Float) {
        self.id = id
        self.title = title
        self.progress = progress
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DownloadableFile, rhs: DownloadableFile) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DownloadableFile {
    static func generateInitialFiles() -> [DownloadableFile]{
        return [DownloadableFile(id: "001", title: "File #1", progress: 0)]
    }
}
