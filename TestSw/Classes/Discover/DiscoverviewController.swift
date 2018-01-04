//
//  DiscoverviewController.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit
private let kChatToolsViewHeight : CGFloat = 44

class DiscoverviewController: UIViewController, Emitterables {

    @IBOutlet weak var bgImageView: UIView!
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DiscoverviewController {
    fileprivate func setUpUI() {
        
//        setupBlurView()
        setUpBottomView()
    }
    
//    fileprivate func setupBlurView() {
//        let blur = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        blurView.frame = bgImageView.bounds
//        bgImageView.addSubview(blurView)
//    }
    
    fileprivate func setUpBottomView () {
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
    }
    
}

// 监听事件
extension DiscoverviewController {
    @IBAction func exitBtnClick() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
        case 3:
            print("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5 - 44)
            sender.isSelected ? startEmitterables(point): stopEmitterables()
            
        default:
        fatalError("未处理按钮")
        }
    }

}

extension DiscoverviewController {
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
        }
    }
}

extension DiscoverviewController : ChatToolsViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        print(message)
    }
}















