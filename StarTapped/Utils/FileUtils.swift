//
//  FileUtils.swift
//  StarTapped
//
//  Created by Nova Maday on 1/8/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class FileUtils {
    
    func fileToBase64(filePath: String) -> JSON {
        let fileUrl = NSURL(fileURLWithPath: filePath)
        let fileData = NSData(contentsOfFile: filePath)
        let fileStream:String = fileData?
            .base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) ?? ""
        
        return [
            "type": fileUrl.mimeType(),
            "encoded": fileStream
        ]
    }
}
