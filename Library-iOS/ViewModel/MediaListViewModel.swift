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
        
        // 創建一個 PHFetchOptions 對象
        let options = PHFetchOptions()

        // 檢索所有媒體類型（照片和視頻）
        options.includeAssetSourceTypes = [.typeUserLibrary, .typeCloudShared, .typeiTunesSynced]

        // 獲取 PHFetchResult 對象，用於檢索所有媒體項目
        let allAssets = PHAsset.fetchAssets(with: options)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // 遍歷所有媒體項目
        allAssets.enumerateObjects { (asset, index, stop) in
            // 做一些處理，例如獲取媒體的標題、創建日期等
            var mediaModel = MediaModel()
            
            if let resources = PHAssetResource.assetResources(for: asset).first {
                mediaModel.fileName = resources.originalFilename
            }
            
            if let createDate = asset.creationDate {
                mediaModel.creationDate = dateFormatter.string(from: createDate)
            }
            
            mediaModel.mediaType = asset.mediaType
            
            if asset.mediaType == .image {
                self.getImageDataFunction(asset: asset, mediaModel: mediaModel)
            } else if asset.mediaType == .video {
                self.getVideoDataFunction(asset: asset, mediaModel: mediaModel)
            }
        }
        
        print(self.mediaList.count)
    }
    
    private func getImageDataFunction(asset: PHAsset, mediaModel: MediaModel) {
        var model = mediaModel
        
        // 如果需要獲取實際的媒體數據，可以使用 PHImageManager
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isNetworkAccessAllowed = true // 允許下載iCloud上的媒體
        requestOptions.deliveryMode = .highQualityFormat
        
        // 如讀不到 Data Stream，則試著讀取 Image 本身
        imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: requestOptions) { (image, info) in
            if let image = image {
                model.image = image
                self.mediaList.append(model)
            } else {
                // 讀取 Image 的 Data Stream
                imageManager.requestImageDataAndOrientation(for: asset, options: requestOptions) { data, dataUTI, orientation, info in
                    guard let imageData = data else { return }
                    model.mediaData = imageData
                    self.mediaList.append(model)
                }
            }
        }
    }
    
    private func getVideoDataFunction(asset: PHAsset, mediaModel: MediaModel) {
        var model = mediaModel
        let imageManager = PHImageManager.default()
        let requestOptions = PHVideoRequestOptions()
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .highQualityFormat
        imageManager.requestAVAsset(forVideo: asset, options: requestOptions) { avAsset, _, _ in
            guard let avAsset = avAsset else {
                return
            }

            // 放置暫存
            let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(model.fileName)
            print(outputURL)
            do { // delete old video
                try FileManager.default.removeItem(at: outputURL)
            } catch { print(error.localizedDescription) }

            // 建立 AVAssetExportSession 對象，輸出為 MP4 格式。
            let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetHighestQuality)
            exportSession?.outputURL = outputURL
            // set to true, the export session will use a more efficient file format and encoding settings that are better suited for streaming over a network.
            exportSession?.shouldOptimizeForNetworkUse = true
            if let supportType = exportSession?.supportedFileTypes, supportType.contains(.mp4) {
                exportSession?.outputFileType = .mp4
            } else {
                exportSession?.outputFileType = .mov
            }
            exportSession?.exportAsynchronously(completionHandler: {
                DispatchQueue.main.async {
                    guard exportSession?.status == .completed, let outputURL = exportSession?.outputURL else {
                        return
                    }

                    // 讀取輸出文件的數據。
                    let outputData = try? Data(contentsOf: outputURL, options: .mappedIfSafe)
                    model.videoURL = outputURL
                    model.mediaData = outputData
                    self.mediaList.append(model)
                }
            })
        }
    }
}
