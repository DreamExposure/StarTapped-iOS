//
// Created by Nova Maday on 2019-02-25.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed)
    }
}