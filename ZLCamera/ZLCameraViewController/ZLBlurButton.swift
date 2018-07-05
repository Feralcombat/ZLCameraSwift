//
//  ZLBlurButton.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/13.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit
import SnapKit

enum ZLBlurButtonActionType{
    case tap
    case longPress
}

@objc protocol ZLBlurButtonDelegate {
    func blurButtonPressed(button : ZLBlurButton)
    func blurButtonLongPressed(button : ZLBlurButton , began : Bool)
}

class ZLBlurButton: UIVisualEffectView {

    let circleView : UIView = UIView()
    weak var delegate : ZLBlurButtonDelegate? = nil
    
    private let progressView : ZLProgressView = ZLProgressView()

    private var tapGesture : UITapGestureRecognizer? = nil
    private var longGesture : UILongPressGestureRecognizer? = nil
    
    deinit {
        self.longGesture?.removeObserver(self, forKeyPath: "state")
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)

        self.circleView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.contentView.addSubview(self.circleView)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        
        self.longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.longGesture?.minimumPressDuration = 0.8
        
        self.circleView.addGestureRecognizer(self.tapGesture!)
        self.circleView.addGestureRecognizer(self.longGesture!)
        
        self.longGesture?.addObserver(self, forKeyPath: "state", options: .new, context: nil)
        
        self.circleView.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func tap(_ : UITapGestureRecognizer){
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.25
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        let animationValue1 = CATransform3DMakeScale(1.0, 1.0, 1.0)
        let animationValue2 = CATransform3DMakeScale(0.8, 0.8, 1.0)
        let animationValue3 = CATransform3DMakeScale(0.6, 0.6, 1.0)
        let animationValue4 = CATransform3DMakeScale(1.0, 1.0, 1.0)
        animation.values = [animationValue1,animationValue2,animationValue3,animationValue4]
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        self.circleView.layer.add(animation, forKey: nil)
        
        self.delegate?.blurButtonPressed(button: self)
        
    }
    
    @objc private func longPress(_ : UILongPressGestureRecognizer){
        
    }
    
    func setProgress(_ progress : Float) {
        if !self.contentView.subviews.contains(self.progressView) {
            self.progressView.frame = CGRect(x: 2, y: 2, width: self.contentView.bounds.size.width - 4, height: self.contentView.bounds.size.height - 4)
            self.contentView.addSubview(self.progressView)
        }
        self.progressView.setProgress(progress)
    }
    
    func requestEndLongPress() {
        self.longGesture?.isEnabled = false
    }
}

extension ZLBlurButton{
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "state" {
            let state = UIGestureRecognizerState(rawValue: change![NSKeyValueChangeKey.newKey] as! NSNumber.IntegerLiteralType)
            if state == .began{
                self.delegate?.blurButtonLongPressed(button: self, began: true)
            }
            else if state == .ended{
                self.progressView.removeFromSuperview()
                self.delegate?.blurButtonLongPressed(button: self, began: false)
            }
            else if state == .cancelled{
                self.progressView.removeFromSuperview()
                self.delegate?.blurButtonLongPressed(button: self, began: false)
                self.longGesture?.isEnabled = true
            }
        }
        else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
