//
//  MediaListViewModel.swift
//  Library-iOS
//
//  Created by Jim Huang on 2023/3/17.
//

import Foundation
import Photos
import UIKit

class MediaListViewModel: ObservableObject {
    @Published var mediaList = [MediaModel]()
    
    func getAllUserMedia() {
        self.mediaList.removeAll()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let mediaList = MediaManager.manager.getAllSystemMediaFunction()
        mediaList.forEach { asset in
            var mediaModel = MediaModel()
            
            if let resources = PHAssetResource.assetResources(for: asset).first {
                mediaModel.fileName = resources.originalFilename
            }
            
            if let createDate = asset.creationDate {
                mediaModel.creationDate = dateFormatter.string(from: createDate)
            }
            
            mediaModel.mediaType = asset.mediaType
            
            if asset.mediaType == .image {
                MediaManager.manager.getImageDataFunction(asset: asset) { result, imageData in
                    if let image = result {
                        mediaModel.image = image
                        self.mediaList.append(mediaModel)
                    } else {
                        guard let imageData = imageData else { return }
                        mediaModel.mediaData = imageData
                        self.mediaList.append(mediaModel)
                    }
                }
            } else if asset.mediaType == .video {
                MediaManager.manager.getVideoDataFunction(asset: asset) { result, videoData in
                    if let videoURL = result {
                        mediaModel.videoURL = videoURL
                    }
                    if let videoData = videoData {
                        mediaModel.mediaData = videoData
                    }
                    self.mediaList.append(mediaModel)
                }
            }
        }
    }
}
