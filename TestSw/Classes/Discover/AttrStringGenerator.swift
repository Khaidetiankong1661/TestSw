//
//  AttrStringGenerator.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/18.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

class AttrStringGenerator {
    
}

extension AttrStringGenerator {
    class func generateJoinLeaveRoom(_ username : String, _ isJoin : Bool) -> NSAttributedString {
        let roomString = "\(username)" + (isJoin ? "进入房间" : "离开房间")
        let roomMAttr = NSMutableAttributedString(string: roomString)
        roomMAttr.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.characters.count))
        
        return roomMAttr
    }
    
    class func generateTextMessage(_ username : String, _ message : String) -> NSAttributedString {
        let chatMessage = "\(username): \(message)"
        let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
        
        // 3.将名称修改成橘色
        chatMsgMAttr.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.orange], range: NSRange(location: 0, length: username.characters.count))
        
        // 正则表达式
        let pattern = "\\[.*?\\]"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return chatMsgMAttr }
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.characters.count))
        
        
        for i in (0..<results.count).reversed() {
            let result = results[i]
            let emoticonName = (chatMessage as NSString).substring(with: result.range)
            
            // 4.4.根据结果创建对应的图片
            guard let image = UIImage(named: emoticonName) else {
                continue
            }
            // 4.5.根据图片创建NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 15)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            // 4.6.将imageAttrStr替换到之前文本的位置
            chatMsgMAttr.replaceCharacters(in: result.range, with: imageAttrStr)
        }
        return chatMsgMAttr
    }
}
