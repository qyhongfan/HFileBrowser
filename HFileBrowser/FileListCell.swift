//
//  FileListCell.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/23.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit
import AVFoundation



class FileListCellModel: NSObject {
    var name = ""
    var filetype = FileType.Folder
    var size:Double = 0
    
    init(name:String,type:FileType=FileType.Folder,size:Double=0) {
        self.name = name
        self.filetype = type
        self.size = size
    }
}

class FileListCell: UITableViewCell {
    static let CellIdentifier = "FileListCell"
    static let CellHeight:CGFloat = 60
    
    var coverView :UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    var nameLabel :UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 60, green: 79, blue: 94, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var desLabel :UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red:151,green: 151,blue: 151,alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layoutCell() {
        
    }
    
    func setCell(_ path:String) {
        self.imageView?.image = getCoverOfFile(path)
        self.textLabel?.text = FileHelper().getFileName(path)
        self.textLabel?.textColor = UIColor.black
        self.textLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    func getCoverOfFile(_ path:String) -> UIImage {
        let type = FileHelper().getFileType(path)
        switch type {
        case FileType.Folder:
            return HFileBrowserAssets.folderIcon
            
        case FileType.Image:
            if let image = UIImage(contentsOfFile:path) {
                return image
            }
        case FileType.Video:
            return getCoverOfVideo(path)
        case FileType.Text:
            return HFileBrowserAssets.textIcon
        default:
            return HFileBrowserAssets.unknownTypeIcon
        }
        return UIImage()
    }
    
    fileprivate func getCoverOfVideo(_ path:String) -> UIImage{
        let videoURL = URL(fileURLWithPath: path)
        let avAsset = AVAsset(url: videoURL)
        //生成视频截图
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0,600)
        var actualTime:CMTime = CMTimeMake(Int64(avAsset.duration.seconds/2),0)
        let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        let frameImg = UIImage(cgImage: imageRef)
        return frameImg
    }

}
