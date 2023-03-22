//
//  MediaManager.swift
//  Library-iOS
//
//  Created by Jim Huang on 2023/3/17.
//

import Foundation
import Photos
import UIKit

class MediaManager {
    static let manager: MediaManager = MediaManager()
    
    private let taskPool: DispatchSemaphore
    private let queue = DispatchQueue(label: "com.asuscloud.require_media", qos: .background)

    init() {
        self.taskPool = DispatchSemaphore(value: 5)
    }

    /// 取得系統所有相片與影片 (包含 iCloud 相片)
    /// - Parameter sourceType: 欲存取的媒體類型 (.typeUserLibrary, .typeCloudShared, .typeiTunesSynced)
    func getAllSystemMediaFunction(sourceType: PHAssetSourceType = [.typeUserLibrary, .typeCloudShared, .typeiTunesSynced]) -> [PHAsset] {
        var assetsList = [PHAsset]()
        
        // 創建一個 PHFetchOptions 對象
        let options = PHFetchOptions()

        // 檢索所有媒體類型（照片和視頻）
        options.includeAssetSourceTypes = sourceType

        // 獲取 PHFetchResult 對象，用於檢索所有媒體項目
        let allAssets = PHAsset.fetchAssets(with: options)

        // 遍歷所有媒體項目
        allAssets.enumerateObjects { (asset, index, stop) in
            // 做一些處理，例如獲取媒體的標題、創建日期等
            assetsList.append(asset)
        }
        
        return assetsList
    }
    
    /// 取的相片的實際 Data 或 UIImage
    /// - Parameters:
    ///   - asset: PHAsset
    ///   - resultHandler: Callback
    func getImageDataFunction(asset: PHAsset, resultHandler: @escaping ((_ result: UIImage?, _ imageData: Data?) -> Void)) {
        self.queue.async {
            self.taskPool.wait()
            
            // 如果需要獲取實際的媒體數據，可以使用 PHImageManager
            let imageManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isNetworkAccessAllowed = true // 允許下載iCloud上的媒體
            requestOptions.deliveryMode = .highQualityFormat
            
            // 如讀不到 Data Stream，則試著讀取 Image 本身
            imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: requestOptions) { (image, info) in
                if let image = image {
                    resultHandler(image, nil)
                    
                    self.taskPool.signal()
                } else {
                    imageManager.requestImageDataAndOrientation(for: asset, options: requestOptions) { data, dataUTI, orientation, info in
                        if let imageData = data {
                            resultHandler(nil, imageData)
                        } else {
                            resultHandler(nil, nil)
                        }
                        
                        self.taskPool.signal()
                    }
                }
            }
        }
    }
    
    /// 取的影片的實際 Data 或 UIImage
    /// - Parameters:
    ///   - asset: PHAsset
    ///   - resultHandler: Callback
    func getVideoDataFunction(asset: PHAsset, resultHandler: @escaping ((_ result: URL?, _ videoData: Data?) -> Void)) {
        self.queue.async {
            self.taskPool.wait()

            let imageManager = PHImageManager.default()
            let requestOptions = PHVideoRequestOptions()
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.deliveryMode = .highQualityFormat
            imageManager.requestAVAsset(forVideo: asset, options: requestOptions) { avAsset, _, _ in
                guard let avAsset = avAsset, let resources = PHAssetResource.assetResources(for: asset).first else {
                    return
                }
                
                // 將影片輸出至暫存位置
                let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(resources.originalFilename)
                print(outputURL)
                do {
                    // delete temp file
                    if FileManager.default.fileExists(atPath: outputURL.path) {
                        try FileManager.default.removeItem(at: outputURL)
                    }
                } catch { }

                // 建立 AVAssetExportSession 對象，輸出為 MP4 格式。
                let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetHighestQuality)
                // Must：需指定輸出路徑
                exportSession?.outputURL = outputURL
                // set to true, the export session will use a more efficient file format and encoding settings that are better suited for streaming over a network.
                exportSession?.shouldOptimizeForNetworkUse = true
                // Must：需指定輸出格式
                if let supportType = exportSession?.supportedFileTypes, supportType.contains(.mp4) {
                    exportSession?.outputFileType = .mp4
                } else {
                    exportSession?.outputFileType = .mov
                }
                
                // 串流輸出影片 Data
                exportSession?.exportAsynchronously(completionHandler: {
                    self.taskPool.signal()

                    DispatchQueue.main.async {
                        switch exportSession?.status {
                        case .completed:
                            if let outputData = try? Data(contentsOf: outputURL, options: .mappedIfSafe) {
                                resultHandler(outputURL, outputData)
                            } else {
                                resultHandler(outputURL, nil)
                            }
                            break
                        default:
                            resultHandler(outputURL, nil)
                        }
                    }
                })
            }
        }
    }
}
