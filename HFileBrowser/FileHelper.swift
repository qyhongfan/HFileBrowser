//
//  FileHelper.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/23.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit
enum FileType:String {
    case Image = "image"
    case Video = "video"
    case Text  = "text"
    case Folder = "folder"
    case UnKnown = "UnKnown"
    case None = "none" //不存在
}

class FileHelper: NSObject {
    let supportImageTypes = ["png","tif","jpg","jpeg","gif","cur","bmp"]
    let supportVideoTpyes = ["mp4","avi","wmv","3gp","mov"]
    let supportTextTypes = ["txt","plist","xcconfig","html","json"]
    
    var fileManager = FileManager.default
    func isDirectory(_ path:String) -> Bool{
        var isDir = ObjCBool(false)
        _ = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    
    func isFileExist(_ path:String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    func getSubFiles(_ path:String) -> [String] {
        if isDirectory(path) {
            if let fileArray = fileManager.subpaths(atPath: path){
                return fileArray
            }else{
                return [String]()
            }
        }else{
            return [String]()
        }
    }
    
    func getFileType(_ path:String) -> FileType {
        if isFileExist(path) {
            if isDirectory(path) {
                return FileType.Folder
            }else{
                let name = getFileName(path).lowercased() as NSString
                let exten = name.pathExtension
                
                if supportImageTypes.contains(exten) {
                    return FileType.Image
                }else if supportVideoTpyes.contains(exten){
                    return FileType.Video
                }else if supportTextTypes.contains(exten) {
                    return FileType.Text
                }else{
                    return FileType.UnKnown
                }
            }
        }
        return FileType.None
    }
    
    func getSizeOfFile(_ path:String) -> Float {
        var fileSize:Float = 0.0
        if fileManager.fileExists(atPath: path) {
            do {
                if let attr: NSDictionary = try fileManager.attributesOfItem(atPath: path) as NSDictionary? {
                    fileSize = Float(attr.fileSize())
                }
            } catch {
            }
        }
        return fileSize;
    }
    
    func getSizeOfDirectory(_ path:String) -> Float {
        if path.characters.count == 0 {
            return 0
        }

        if !fileManager.fileExists(atPath: path){
            return 0
        }
        var fileSize:Float = 0.0
        do {
            let files = try fileManager.contentsOfDirectory(atPath: path)
            for file in files {
                fileSize = fileSize + getSizeOfFile(file)
            }
        }catch {
        }
        return fileSize
    }
    
    func deleteFile(_ path:String) -> Bool {
        if isDirectory(path) {  //folder
            let fileArray = fileManager.subpaths(atPath: path)
            if let fileArrayTmp = fileArray {
                for pa in fileArrayTmp {
                    if !deleteFileAtPath(pa){
                        return false
                    }
                }
            }
            return true
        }else{ //file
            if deleteFileAtPath(path){
                return true
            }
        }
        return false
    }
    func deleteFileAtPath(_ path:String) -> Bool{
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch{
            return false
        }
        return true
    }
    
    func getFileName(_ path:String) ->String{
        let temp = path as NSString
        return temp.lastPathComponent
    }
    
    func getFilePathExtension(_ path:String) -> String {
        if isDirectory(path) {
            return ""
        }else{
            let name = getFileName(path) as NSString
            return name.pathExtension
        }
    }
    
}
