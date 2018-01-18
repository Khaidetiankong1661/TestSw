//
//  HXSocket.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/10.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

protocol HXSocketDelegate : class {

    func socket(_ sokect : HXSocket, joinRoom user : UserInfo)
    func socket(_ sokect : HXSocket, leaveRoom user : UserInfo)
    func socket(_ sokect : HXSocket, chatMsg : ChatMessage)
    func socket(_ sokect : HXSocket, giftMsg : GiftMessage)
}

class HXSocket {
    weak var delegate : HXSocketDelegate?
    fileprivate var tcpClient : TCPClient
    fileprivate var userInfo : UserInfo.Builder = {
       let userInfo = UserInfo.Builder()
        userInfo.name = "why\(arc4random_uniform(10))"
        userInfo.level = 20
//        userInfo.iconUrl = "good6_30x30"
        return userInfo
    }()
    
    init(addr : String, port : Int) {
        tcpClient = TCPClient(addr : addr, port : port)
    }
}


extension HXSocket {
    func connectServer() -> Bool {
        return tcpClient.connect(timeout: 5).0
    }
    
    func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                guard let lMsg = self.tcpClient.read(4) else {
                    continue
                }
                // 读取data的长度
                let headData = Data(bytes: lMsg, count: 4)
                var length : Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 读取类型 :看自己的项目里是否有这个
                guard let typeMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                print(type)
                
                // 根据长度 读取真实的长度
                guard let msg = self.tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                // 处理消息
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)
                }
                
            }
        }
    }
    
    fileprivate func handleMsg(type : Int, data : Data) {
        switch type {
        case 0, 1:
            let user = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
            print("")
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: data)
            delegate?.socket(self, chatMsg: chatMsg)
            print("")
        case 3:
            let gifMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMsg: gifMsg)
            print("")
        default:
            print("未知类型")
        }
    }
}

extension HXSocket {
    func sendJoinRoom() {
        let msgData = (try! userInfo.build()).data()
        sendMsg(data: msgData, type: 0)
    }

    func sendLeaveRoom() {
        let msgData = (try! userInfo.build()).data()
        sendMsg(data: msgData, type: 1)
    }

    func sendTextMsg(message : String) {
        let chatMessage = ChatMessage.Builder()
        chatMessage.user = try! userInfo.build()
        chatMessage.text = message

        let chatMsgData = (try! chatMessage.build()).data()
        sendMsg(data: chatMsgData, type: 2)
    }

    func sendGiftMsg(giftName : String, giftURL : String, giftCount : Int) {
        let gifMsg = GiftMessage.Builder()
        gifMsg.user = try! userInfo.build()
        gifMsg.giftname = giftName
//        gifMsg.giftUrl = giftURL
//        gifMsg.giftcount = Int32(giftCount)

        
        let gifData = (try! gifMsg.build()).data()
        sendMsg(data: gifData, type: 3)
    }
    
    // 发送心跳包
    func sendHeartBeat() {
        let heartString = "I am is heart beat;"
        let heartData = heartString.data(using: .utf8)!
        
        sendMsg(data: heartData, type: 100)
    }
    
    func sendMsg(data : Data, type : Int) {
        // 将消息长度写入data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
       
//        // 消息类型
        var temType = type
        let typeData = Data(bytes: &temType, count: 2)
        
        // 发送消息
        let totalData = headerData + typeData + data
//        let totalData = headerData + data
        tcpClient.send(data: totalData)
        
    }
    func sendMsg(str: String) {
        tcpClient.send(str: str)
    }
}


