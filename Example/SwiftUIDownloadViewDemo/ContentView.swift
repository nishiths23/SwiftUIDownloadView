//
//  ContentView.swift
//  SwiftUIDownloadViewDemo
//
//  Created by Nishith on 16/06/2019.
//  Copyright © 2019 Nishith. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    @ObjectBinding var viewModel: FilesViewModel
    var body: some View {
        NavigationView{
            List(viewModel.files) { file in
                HStack {
                    Text(file.title)
                    Spacer()
                    if file.isDownloading {
                        SwiftUIDownloadView(progress: file.progress) {
                            self.cancelDownload(file)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Downloading files"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.addFile()
            }, label: {
                Text("Add new file")
            }))
        }
    }
    
    func cancelDownload(_ file: DownloadableFile) {
        viewModel.cancelDownload(file)
    }
    
    func addFile() {
        viewModel.addNewFile()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: FilesViewModel(DownloadableFile.generateInitialFiles()))
    }
}
#endif
