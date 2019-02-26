//
//  FileUtils.swift
//  StarTapped
//
//  Created by Nova Maday on 1/8/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FileUtils {
    
    func fileTooBig(filePath: String) -> Bool {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            let fileSizeInBytes = attr[FileAttributeKey.size] as! UInt64
            
            let fileSizeInMb = fileSizeInBytes / (1024 * 1024)
            
            if fileSizeInMb > 10 {
                return true
            } else {
                return false
            }
        } catch {
            return true //Default to it being too big...
        }
    }
    
    func fileToBase64(filePath: String) -> [String: String] {
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let fileData = NSData(contentsOfFile: filePath)
        let fileStream:String = fileData?
            .base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) ?? ""
        
        return [
            "type": fileUrl.mimeType(),
            "name": (filePath as NSString).lastPathComponent,
            "encoded": fileStream
        ]
    }

    func imageToBase64(image: UIImage) -> [String: String] {
        let baseString: String = image.toBase64()!

        return [
            "type": "image/png",
            "name": "Camera Image",
            "encoded": baseString
        ]
    }
}
