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
        label.text = "未能打开此文件"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    var tryButton1:UIButton = {
        var btn = UIButton()
        btn.setTitle("试一下", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        return btn
    }()
    var tryButton2:UIButton = {
        var btn = UIButton()
        btn.setTitle("再试一下", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        return btn
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
        self.view.addSubview(tryButton1)
        self.view.addSubview(tryButton2)
        self.view.backgroundColor = UIColor.white
        emptyLabel.frame = CGRect(x: 0, y: HScreenHeight/2 - 40, width: HScreenWidth, height: 40)
        tryButton1.frame = CGRect(x: HScreenWidth/2 - 60, y: HScreenHeight/2 + 20, width: 120, height: 30)
        tryButton1.addTarget(self, action: #selector(onTry1), for: .touchUpInside)
        tryButton2.frame = CGRect(x: HScreenWidth/2 - 60, y: HScreenHeight/2 + 70, width: 120, height: 30)
        tryButton2.addTarget(self, action: #selector(onTry2), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    func onTry1() {
        navigationController?.pushViewController(TextPreviewController(path:self.filePath,isTypeFirst:true), animated: true)
    }
    func onTry2() {
        navigationController?.pushViewController(TextPreviewController(path:self.filePath), animated: true)
    }
}
