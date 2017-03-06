//
//  HFileBrowserAssets.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/3/6.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class HFileBrowserAssets: NSObject {
    public class var folderIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "folderIcon") }
    public class var textIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "textIcon") }
    public class var unknownTypeIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "unknownTypeIcon") }
    public class var videoTypeIcon: UIImage { return HFileBrowserAssets.bundledImage(named: "videoTypeIcon") }
    
    internal class func bundledImage(named name: String) -> UIImage {
        let bundle = NSBundle(forClass: HFileBrowserAssets.self)
        let image = UIImage(named: name, inBundle:bundle, compatibleWithTraitCollection:nil)
        if let image = image {
            return image
        }
        return UIImage()
    }
}
