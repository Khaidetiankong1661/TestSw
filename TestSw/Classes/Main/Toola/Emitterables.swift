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
    func startEmitterables(_ point : CGPoint) {
        // 创建发射器
        let emi = CAEmitterLayer()
        // 发射器位置
        emi.emitterPosition = point
        // 开取三维效果
        emi.preservesDepth = true
        
        // 4.创建例子, 并且设置例子相关的属性
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            // 4.1.创建例子Cell
            let cell = CAEmitterCell()
            
            // 4.2.设置粒子速度
            cell.velocity = 150
            cell.velocityRange = 110
            
            // 4.3.设置例子的大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            // 4.4.设置粒子方向
            cell.emissionLongitude = CGFloat(-M_PI_2)
            cell.emissionRange = CGFloat(M_PI_2 / 6)
            
            // 4.5.设置例子的存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 1.0
            
            // 4.6.设置粒子旋转
            cell.spin = CGFloat(M_PI_2)
            cell.spinRange = CGFloat(M_PI_2 / 2)
            
            // 4.6.设置例子每秒弹出的个数
            cell.birthRate = 2
            
            // 4.7.设置粒子展示的图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            // 4.8.添加到数组中
            cells.append(cell)
        }
        
        // 5.将粒子设置到发射器中
        emi.emitterCells = cells
        
        // 添加到父layer
        view.layer.addSublayer(emi)
        
    }
    func stopEmitterables() {
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}
