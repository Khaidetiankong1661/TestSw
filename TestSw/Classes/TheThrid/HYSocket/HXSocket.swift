//
//  HXSocket.swift
//  TestSw
//
//  Created by hongbaodai on 2018/1/10.
//  Copyright © 2018年 wang. All rights reserved.
//

import UIKit

//protocol HXSocketDelegate : class {
//
//}

class HXSocket {
    
    fileprivate var tcpClient : TCPClient
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
                guard let typeMsg = self.tcpClient.read(length) else {
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
            print("")
        default:
            print("")
        }
    }
}

extension HXSocket {
    func sendJoinRoom() {
//        let msgData =
    }
    
    func sendMsg(data : Data, type : Int) {
        // 将消息长度写入data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
       
//        // 消息类型
//        var temType = type
//        let typeData = Data(bytes: &temType, count: 2)
        
        // 发送消息
//        let totalData = headerData + typeData + data
        let totalData = headerData + data
        tcpClient.send(data: totalData)
        
    }
    func sendMsg(str: String) {
        tcpClient.send(str: str)
    }
}


