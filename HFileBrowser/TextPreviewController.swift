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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
