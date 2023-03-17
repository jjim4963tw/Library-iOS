//
//  MediaListView.swift
//  Library-iOS
//
//  Created by Jim Huang on 2023/3/15.
//

import SwiftUI
import AVKit

struct MediaListView: View {
    @StateObject private var viewModel: MediaListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MediaListViewModel())
    }
    
    var body: some View {
        VStack {
            List(self.viewModel.mediaList, id: \.self) { item in
                VStack {
                    if item.mediaType == .video {
                        VideoPlayer(player: AVPlayer(url: item.videoURL!))
                            .frame(height: 400)
                    } else {
                        if item.mediaData != nil {
                            Image(uiImage: UIImage(data: item.mediaData!)!)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(uiImage: item.image!)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Text(item.fileName)
                    Text(item.creationDate)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listStyle(.plain)
        }
        .onAppear {
            self.viewModel.getAllUserMedia()
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView()
    }
}
