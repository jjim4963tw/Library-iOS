//
//  ImageModel.swift
//  Library-iOS
//
//  Created by Jim Huang on 2023/3/17.
//

import Foundation
import UIKit
import Photos

struct MediaModel: Hashable {
    var id = UUID()
    var fileName = ""
    var mediaType = PHAssetMediaType.unknown
    var creationDate: String = ""
    var image: UIImage? = nil
    var videoURL: URL? = nil
    var mediaData: Data? = nil
}
