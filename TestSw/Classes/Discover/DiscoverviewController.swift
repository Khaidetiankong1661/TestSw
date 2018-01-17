//
//  DiscoverviewController.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/4.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit
private let kChatToolsViewHeight : CGFloat = 44
private let kGiftlistViewHeight : CGFloat = kScreenH * 0.5

class DiscoverviewController: UIViewController, Emitterables {

    @IBOutlet weak var bgImageView: UIView!
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    fileprivate lazy var giftListView : GiftListView = GiftListView.loadFromNib()
    fileprivate lazy var socket : HXSocket = HXSocket(addr: "192.168.1.155", port: 7878)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if socket.connectServer() {
            print("连接成功")
            socket.startReadMsg()
            
//            socket.sendJoinRoom()
            socket.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DiscoverviewController {
    fileprivate func setUpUI() {
        
        setUpBottomView()
    }
    
    fileprivate func setUpBottomView () {
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        view.addSubview(giftListView)
        giftListView.delegate = self
    }
    
}

// 监听事件
extension DiscoverviewController {
    @IBAction func exitBtnClick() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatToolsView.inputTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.giftListView.frame.origin.y = kScreenH
        })
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
               self.giftListView.frame.origin.y = kScreenH - kGiftlistViewHeight
            })
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

extension DiscoverviewController : ChatToolsViewDelegate, GiftListViewDelegate {
    func chatToolsView(toolView: ChatToolsView, message: String) {
        print(message)
//        socket.sendTextMsg(message: message)
    }
    
    func giftListView(gitfListView: GiftListView, giftModel: GiftModel) {
        print(giftModel.subject)
//        socket.sendGiftMsg(giftName: giftModel.subject, giftURL: giftModel.img2, giftCount: 1)
    }
}



extension DiscoverviewController : HXSocketDelegate {
//    func socket(_ sokect: HXSocket, joinRoom user: UserInfo) {
//
//    }
//    func socket(_ sokect: HXSocket, leaveRoom user: UserInfo) {
//
//    }
//    func socket(_ sokect: HXSocket, chatMsg: ChatMessage) {
//
//    }
//    func socket(_ sokect: HXSocket, giftMsg: GiftMessage) {
//
//    }
}
