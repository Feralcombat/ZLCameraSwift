//
//  ZLPhotoPreviewViewController.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/13.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit

class ZLPhotoPreviewViewController: UIViewController {
    var image : UIImage? = nil
    
    private let imageView : UIImageView = UIImageView()
    private let backButton : UIButton = UIButton(type: .custom)
    private let confirmButton : UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func backButton_pressed(_ : UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    
    private func loadUI(){
        self.imageView.image = self.image
        self.view.addSubview(self.imageView)
        
        self.backButton.setTitle("返回", for: .normal)
        self.backButton.setTitleColor(UIColor.blue, for: .normal)
        self.backButton.addTarget(self, action: #selector(backButton_pressed(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButton)
        
        self.backButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-24)
            make.width.lessThanOrEqualTo(60)
            make.height.equalTo(24)
        }
        
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
