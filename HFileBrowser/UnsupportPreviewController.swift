//
//  UnsupportPreviewController.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/27.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class UnsupportPreviewController: UIViewController {

    var filePath = ""
    var emptyLabel:UILabel = {
        var label = UILabel()
        label.text = "暂不支持此类型文件预览\n正在努力中。。。"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
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
        self.view.addSubview(emptyLabel)
        self.view.backgroundColor = UIColor.white
        emptyLabel.frame = CGRect(x: 0, y: HScreenHeight/2 - 40, width: HScreenWidth, height: 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
