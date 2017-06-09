//
//  AddNewFileController.swift
//  HFileBrowser
//
//  Created by hurry.qin on 2017/6/8.
//  Copyright © 2017年 hurry.qin. All rights reserved.
//

import UIKit

class AddNewFileController: UIViewController {
    var filePath:String?
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.text = "文件名:"
        return label
    }()
    var nameText: UITextField = {
        let field = UITextField()
        field.placeholder = " 新文件"
        field.font = UIFont.systemFont(ofSize: 15)
        field.textColor = UIColor.black
        field.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return field
    }()
    var contentText: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return textView
    }()
    var cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        return btn
    }()
    var surelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitleColor(UIColor.gray, for: .highlighted)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    init(path:String) {
        filePath = path
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(nameLabel)
        view.addSubview(nameText)
        view.addSubview(contentText)
        view.addSubview(cancelBtn)
        view.addSubview(surelBtn)
        nameText.delegate = self
        cancelBtn.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        surelBtn.addTarget(self, action: #selector(onSure), for: .touchUpInside)
        nameText.becomeFirstResponder()
        nameLabel.frame = CGRect(x:23 ,y:60,width: 60,height: 30)
        nameText.frame = CGRect(x:23 + 60 ,y:60,width: UIScreen.main.bounds.size.width - 60 - 46,height: 30)
        contentText.frame = CGRect(x:23 ,y:110,width: UIScreen.main.bounds.size.width - 46,height: UIScreen.main.bounds.height - 380)
        cancelBtn.frame = CGRect(x:10 ,y:20,width: 40,height: 25)
        surelBtn.frame = CGRect(x:UIScreen.main.bounds.size.width - 50 ,y:20,width: 40,height: 25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func  onCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onSure() {
        guard let path = filePath,let name = nameText.text else {
            return
        }
        do {
            try contentText.text.write(toFile: "\(path)/\(name).txt", atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            let alertController = UIAlertController(title: "错误",message: "\(error.description)",preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "知道啦", style: .default, handler: nil)
            alertController.addAction(errorAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddNewFileController:UITextFieldDelegate{
    func checkSurBtnStatus(_ textField: UITextField) {
        guard let text = textField.text else{
            return
        }
        if text.lengthOfBytes(using: .utf8) > 1{
            surelBtn.setTitleColor(UIColor.blue, for: .normal)
            surelBtn.setTitleColor(UIColor.gray, for: .highlighted)
            surelBtn.isUserInteractionEnabled = true
        }else{
            surelBtn.setTitleColor(UIColor.gray, for: .normal)
            surelBtn.setTitleColor(UIColor.gray, for: .highlighted)
            surelBtn.isUserInteractionEnabled = false
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       checkSurBtnStatus(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkSurBtnStatus(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSurBtnStatus(textField)
        return true
    }
}
