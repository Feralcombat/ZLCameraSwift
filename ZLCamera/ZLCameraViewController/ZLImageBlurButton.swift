//
//  ZLImageBlurButton.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/13.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit
import SnapKit

class ZLImageBlurButton: UIVisualEffectView {
    private let imageView : UIImageView = UIImageView()
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        self.imageView.contentMode = .center
        self.contentView.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setContentImage(_ image : UIImage!) {
        self.imageView.image = image
    }
}
