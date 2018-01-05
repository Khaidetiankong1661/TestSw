//
//  ChatToolsView.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

protocol ChatToolsViewDelegate : class {
    func chatToolsView(toolView : ChatToolsView, message : String)
}

class ChatToolsView: UIView, NibLoadable {

    weak var delegate : ChatToolsViewDelegate?
    fileprivate var emotionBut : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
    fileprivate lazy var emoticonView : EmotionView = EmotionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 250))

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendMsgBtn: UIButton!
    

    override func awakeFromNib() {
         super.awakeFromNib()
        
        setUpUI()
    }
    
    
    @IBAction func textFieldDidEdit(_ sender : UITextField) {
        sendMsgBtn.isEnabled = sender.text!.characters.count != 0
    }
    
    @IBAction func sendBtnClick(_ sender : UIButton) {
        let message = inputTextField.text!
        
        inputTextField.text = ""
        sender.isEnabled = false
        
        delegate?.chatToolsView(toolView: self, message: message)
    }
}

extension ChatToolsView {
    fileprivate func setUpUI() {
        emotionBut.setImage(UIImage(named:  "chat_btn_emoji"), for: .normal)
        emotionBut.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
            emotionBut.addTarget(self, action: #selector(emoticonBtnClick(_:)), for: .touchUpInside)
        
        inputTextField.rightView = emotionBut
        inputTextField.rightViewMode = .always
        inputTextField.allowsEditingTextAttributes = true
        
        emoticonView.emotionClickCallBlock = {[weak self] emotion in

            if emotion.emoticonName  == "delete-n" {
                self?.inputTextField.deleteBackward()
                return
            }
            
            guard let range = self?.inputTextField.selectedTextRange else { return }
            
        }
        
    }
}

extension ChatToolsView {
    @objc fileprivate func emoticonBtnClick(_ btn : UIButton) {
        btn.isSelected = !btn.isSelected
//        // 切换键盘
        let range = inputTextField.selectedTextRange
        inputTextField.resignFirstResponder()
        inputTextField.inputView = inputTextField.inputView == nil ? emoticonView : nil
        inputTextField.becomeFirstResponder()
        inputTextField.selectedTextRange = range
        
    }
}


