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
let HScreenWidth = UIScreen.main.bounds.width
let HScreenHeight = UIScreen.main.bounds.height

open class HFileBrowser: UIViewController {

    var path:String = ""
    var files = [String]()
    var emptyLabel:UILabel = {
        var label = UILabel()
        label.text = "文件夹为空"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    
    var tableView :UITableView = {
        var view = UITableView(frame:CGRect(x: 0, y: 0, width: HScreenWidth, height: HScreenHeight),style: .grouped)
        return view
    }()
    
    public init(path:String,frame:CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.view.frame = frame
        if FileHelper().isFileExist(path) {
            self.path = path
        }else{
            self.path = NSHomeDirectory()
        }
        navigationItem.title = FileHelper().getFileName(path)
        do{
            try files = FileManager.default.contentsOfDirectory(atPath: path)
            reloadTableView()
        }catch{
            
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.view.addSubview(emptyLabel)
        self.navigationItem.title = FileHelper().getFileName(path)
        tableView.register(FileListCell.self, forCellReuseIdentifier: FileListCell.CellIdentifier)
        emptyLabel.frame = CGRect(x: 0, y: HScreenHeight/2 - 20, width: HScreenWidth, height: 20)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableView(){
        if files.count == 0 {
            emptyLabel.isHidden = false
        }else{
            emptyLabel.isHidden = true
        }
        tableView.reloadData()
    }
}

extension HFileBrowser:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                playerVC.player = AVPlayer.init(playerItem: AVPlayerItem(url: URL(fileURLWithPath: "\(self.path)/\(path)")))
                navigationController?.pushViewController(playerVC, animated: true)
            }else{
                navigationController?.pushViewController(UnsupportPreviewController(path:"\(self.path)/\(path)"), animated: true)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .default,title: "删除"){ (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            let alertController = UIAlertController(title: "警告",message: "删除文件后无法找回，确认删除吗？",preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { action in
    
            })
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: { action in
                let fullpath = "\(self.path)/\(self.files[indexPath.row])"
                if FileHelper().deleteFile(fullpath){
                    self.files.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }else{
                    let alertController = UIAlertController(title: "警告",message: "文件删除时出错，请重试",preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: { action in
                        tableView.reloadData()
                    })
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            alertController.addAction(cancelAction)
            alertController.addAction(sureAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        return [action]
    }
    
}

extension HFileBrowser:UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FileListCell.CellHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FileListCell.CellIdentifier, for: indexPath) as! FileListCell
        cell.setCell("\(self.path)/\(files[indexPath.row])")
        return cell
    }
}
