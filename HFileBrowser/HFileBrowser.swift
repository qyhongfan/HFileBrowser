//
//  HFileBrowser.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/23.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
let HScreenWidth = UIScreen.mainScreen().bounds.width
let HScreenHeight = UIScreen.mainScreen().bounds.height

public class HFileBrowser: UIViewController {

    var path:String = ""
    var files = [String]()
    var emptyLabel:UILabel = {
        var label = UILabel()
        label.text = "文件夹为空"
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    var tableView :UITableView = {
        var view = UITableView(frame:CGRectMake(0, 0, HScreenWidth, HScreenHeight),style: .Grouped)
        return view
    }()
    
    public init(path:String,frame:CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.path = path
        do{
            try files = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
        }catch{
            
        }
        //TO DO : sort files
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.view.addSubview(emptyLabel)
        self.navigationItem.title = FileHelper().getFileName(path)
        tableView.registerClass(FileListCell.self, forCellReuseIdentifier: FileListCell.CellIdentifier)
        emptyLabel.frame = CGRectMake(0, HScreenHeight/2 - 20, HScreenWidth, 20)
        if files.count == 0 {
            emptyLabel.hidden = false
        }else{
            emptyLabel.hidden = true
        }
        tableView.reloadData()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HFileBrowser:UITableViewDelegate{
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let path = files[indexPath.row]
        if FileHelper().isDirectory("\(self.path)/\(path)") {
            self.navigationController?.pushViewController(HFileBrowser(path:"\(self.path)/\(path)",frame: self.view.bounds), animated: true)
        }else{
            //预览
            if FileHelper().getFileType("\(self.path)/\(path)") == FileType.Image {
                navigationController?.pushViewController(ImagePreviewController(path: "\(self.path)/\(path)"), animated: true)
            }else if FileHelper().getFileType("\(self.path)/\(path)") == FileType.Text{
                navigationController?.pushViewController(TextPreviewController(path:"\(self.path)/\(path)"), animated: true)
            }else if FileHelper().getFileType("\(self.path)/\(path)") == FileType.Video{
                let playerVC = AVPlayerViewController()
                playerVC.player = AVPlayer.init(playerItem: AVPlayerItem(URL: NSURL(fileURLWithPath: "\(self.path)/\(path)")))
                navigationController?.pushViewController(playerVC, animated: true)
            }else{
                navigationController?.pushViewController(UnsupportPreviewController(), animated: true)
            }
        }
    }
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    public func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .Default,title: "删除"){ (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let alertController = UIAlertController(title: "警告",message: "删除文件后无法找回，确认删除吗？",preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { action in
    
            })
            let sureAction = UIAlertAction(title: "确定", style: .Default, handler: { action in
                let fullpath = "\(self.path)/\(self.files[indexPath.row])"
                if FileHelper().deleteFile(fullpath){
                    self.files.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(sureAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        return [action]
    }
    
}

extension HFileBrowser:UITableViewDataSource{
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FileListCell.CellHeight
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FileListCell.CellIdentifier, forIndexPath: indexPath) as! FileListCell
        cell.setCell("\(self.path)/\(files[indexPath.row])")
        return cell
    }
}
