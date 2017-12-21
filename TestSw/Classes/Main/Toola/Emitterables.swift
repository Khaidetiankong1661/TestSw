//
//  Emitterables.swift
//  TestSw
//
//  Created by hongbaodai on 2017/12/21.
//  Copyright © 2017年 wang. All rights reserved.
//

import UIKit

// 面向协议开发，创建一个协议
protocol Emitterables {
    // 这里只能写声明
}

// where 是一个条件
extension Emitterables where Self : UIViewController {
    // 这里才可以写实现
    func start() {
        // 创建发射器
        let emi = CAEmitterLayer()
        // 发射器位置
        emi.emitterPosition = CGPoint(x: view.bounds.width * 0.5, y: -60)
        // 开取三维效果
        emi.preservesDepth = true
        // 创建粒子cell
        let cell = CAEmitterCell()
        // 速度
        cell.velocity = 150
        cell.velocityRange = 100
        
        // 设置粒子大小
        cell.scale = 0.7
        cell.scaleRange = 0.3
        
        // 粒子方向
        
        cell.emissionLongitude = CGFloat(M_PI_2)
        cell.emissionRange = CGFloat(M_PI_2 / 2)
        // 存活时间
        cell.lifetime = 6
        cell.lifetimeRange = 4
        // 粒子旋转
        cell.spin = CGFloat(M_PI_2)
        cell.spinRange = CGFloat(M_PI_2 / 2)
        // 每秒弹出的个数
        cell.birthRate = 19
        // 展示的图片
        cell.contents = UIImage(named: "good6_30x30")?.cgImage
        // 将粒子添加到发射器中
        emi.emitterCells = [cell]
        // 添加到父layer
        view.layer.addSublayer(emi)
        
    }
    func stop() {
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
    
    
    
    
    
}
