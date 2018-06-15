//
//  ViewController.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/11.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var nameLabel = UILabel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       self.loadUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func action(_ : UITapGestureRecognizer) {
        let vc = ZLCameraViewController(delegate: self as? ZLCameraViewControllerDelegate)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func loadUI(){
        self.nameLabel.text = "点我拍照"
        self.nameLabel.font = UIFont.systemFont(ofSize: 12)
        self.nameLabel.textColor = UIColor.blue
        self.nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        self.nameLabel.center = self.view.center
        self.nameLabel.textAlignment = .center
        self.nameLabel.isUserInteractionEnabled = true
        self.view.addSubview(self.nameLabel)
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(action(_:)))
        self.nameLabel.addGestureRecognizer(gesture)
    }
}

extension ViewController : ZLCameraViewControllerDelegate{
    func cameraViewControllerDidDismiss(_ cameraViewController: ZLCameraViewController) {
        
    }
    
    func cameraViewController(_ cameraViewController: ZLCameraViewController, didFinishPick image: UIImage) {
        
    }
    
    func cameraViewController(_ cameraViewController: ZLCameraViewController, didFinishPickVideo url: URL) {
        
    }
}
