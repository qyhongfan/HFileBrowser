//
//  TextPreviewController.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/27.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class TextPreviewController: UIViewController {
    var filePath = ""
    var textView :UITextView = {
        var view = UITextView()
        view.textColor = UIColor.blackColor()
        view.editable = false
        return view
    }()
    
    init(path:String) {
        super.init(nibName: nil, bundle: nil)
        self.filePath = path
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .Plain, target: self, action: #selector(onEdit))
        textView.frame = self.view.frame
        view.addSubview(textView)
        let type = FileHelper().getFilePathExtension(filePath).lowercaseString
        if type == "plist" {
            let dic = NSDictionary(contentsOfFile:filePath)
            textView.text = dic?.description
        }else{
            var text = ""
            do {
                try text = NSString(contentsOfFile: filePath,encoding: NSUTF8StringEncoding) as String
            } catch  {
                
            }
            textView.text = text
        }
    }
    
    func onEdit() {
        textView.editable = true
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(onSave))
    }
    
    func onSave() {
        textView.editable = false
        do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .Plain, target: self, action: #selector(onEdit))
            try textView.text.writeToFile(self.filePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(onSave))
            let alertController = UIAlertController(title: "错误",message: "\(error.description)",preferredStyle: .Alert)
            let errorAction = UIAlertAction(title: "知道啦", style: .Default, handler: nil)
            alertController.addAction(errorAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let alertController = UIAlertController(title: "",message: "保存成功",preferredStyle: .Alert)
        let sureAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertController.addAction(sureAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
