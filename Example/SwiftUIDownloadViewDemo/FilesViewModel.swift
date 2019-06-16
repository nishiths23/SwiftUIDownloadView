//
//  FilesViewModel.swift
//  SwiftUIDownloadViewDemo
//
//  Created by Nishith on 16/06/2019.
//  Copyright © 2019 Nishith. All rights reserved.
//

import Combine
import SwiftUI

class FilesViewModel: BindableObject {
    let didChange = PassthroughSubject<FilesViewModel, Never>()
    
    private(set) var files: [DownloadableFile] {
        didSet {
            initiateDummyDownload()
            didChange.send(self)
        }
    }
    
    init(_ files:[DownloadableFile]) {
        self.files = files
        initiateDummyDownload()
    }
    
    func cancelDownload(_ file: DownloadableFile) {
        if let index = files.firstIndex(of: file){
            files[index].progress = 1
            files[index].isDownloading = false
            didChange.send(self)
        }
    }
    
    func addNewFile() {
        files.append(DownloadableFile(id: "00\(files.count)", title: "File #\(files.count)", progress: 0))
    }
    
    func initiateDummyDownload() {
        for file in files {
            if file.progress < 1{
                file.isDownloading = true
                file.downloadTimer?.invalidate()
                file.downloadTimer = nil
                file.downloadTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak file, weak self] _ in
                    file?.progress += Float(0.1)
                    file?.isDownloading = true
                    if let progress = file?.progress, progress >= 1 {
                        file?.downloadTimer?.invalidate()
                        file?.downloadTimer = nil
                        file?.isDownloading = false
                    }
                    if let selfRef = self {
                        selfRef.didChange.send(selfRef)
                    }
                })
            }
        }
    }
}
