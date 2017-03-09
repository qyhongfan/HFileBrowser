//
//  HFileBrowserAssets.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/3/6.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class HFileBrowserAssets: NSObject {
    open class var folderIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "folderIcon") }
    open class var textIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "textIcon") }
    open class var unknownTypeIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "unknownTypeIcon") }
    open class var videoTypeIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "videoTypeIcon") }
    
    internal class func bundledImage(named name: String) -> UIImage {
        let bundle = Bundle(for: HFileBrowserAssets.self)
        let image = UIImage(named: name, in:bundle, compatibleWith:nil)
        if let image = image {
            return image
        }
        return UIImage()
    }
}
