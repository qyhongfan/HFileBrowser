//
//  ImagePreviewController.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/2/27.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController {
    var preView:AlbumView!
    var filePath = ""
    
    init(path:String) {
        super.init(nibName: nil, bundle: nil)
        self.filePath = path
        self.preView = AlbumView(path:path)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.view.addSubview(preView)
        preView.frame = self.view.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
