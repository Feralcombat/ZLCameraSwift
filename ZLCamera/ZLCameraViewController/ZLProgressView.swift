//
//  ZLProgressView.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/14.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit

class ZLProgressView: UIView {
    var progress : Float = 0
    private var progressLayer : CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.progressLayer.fillColor = UIColor.clear.cgColor
        self.progressLayer.strokeColor = UIColor.red.cgColor
        self.progressLayer.opacity = 1
//        self.progressLayer.lineCap = kCALineCapRound
        self.progressLayer.lineWidth = 8
        
        self.progressLayer.shadowColor = UIColor.black.cgColor
        self.progressLayer.shadowOffset = CGSize(width: 1, height: 1)
        self.progressLayer.shadowOpacity = 0.5
        self.progressLayer.shadowRadius = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let center : CGPoint = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
        let radius : CGFloat = rect.size.width/2
        let startAngle : CGFloat = CGFloat(-(Double.pi/2))
        let endAngle : CGFloat = CGFloat(-.pi/2 + .pi * 2 * self.progress)
        self.progressLayer.frame = self.bounds
        
        let path : UIBezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.progressLayer.path = path.cgPath
        self.progressLayer.removeFromSuperlayer()
        self.layer.addSublayer(self.progressLayer)
    }
    
    func setProgress(_ progress : Float) {
        self.progress = progress
        self.layer.setNeedsDisplay()
    }
}
