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
    private let backButton : ZLImageBlurButton = ZLImageBlurButton(effect: UIBlurEffect(style: .light))
    private let confirmButton : UIButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        self.transitioningDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func confirmButton_pressed(_ : UIButton){
        
    }
    
    @objc private func backButton_pressed(_ : Any){
        self.dismiss(animated: false, completion: nil)
    }
    
    private func loadUI(){
        self.imageView.image = self.image
        self.view.addSubview(self.imageView)
        
        
        
        self.confirmButton.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.confirmButton.frame = CGRect(x: (DeviceWidth() - 80)/2, y: DeviceHeight() - 112, width: 80, height: 80)
        self.confirmButton.setImage(UIImage(named: "video_icon_back_student"), for: .normal)
        self.confirmButton.layer.cornerRadius = 40
        self.confirmButton.clipsToBounds = true
        self.view.addSubview(self.confirmButton)
        
        self.backButton.setContentImage(UIImage(named: "video_icon_back"))
        self.backButton.frame = CGRect(x: (DeviceWidth() - 80)/2, y: DeviceHeight() - 112, width: 80, height: 80)
        self.backButton.layer.cornerRadius = 40
        self.backButton.clipsToBounds = true
        self.view.addSubview(self.backButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButton_pressed(_:)))
        self.backButton.addGestureRecognizer(tapGesture)
        
        
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

extension ZLPhotoPreviewViewController : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC : ZLPhotoPreviewViewController = transitionContext.viewController(forKey: .to) as! ZLPhotoPreviewViewController
        let containerView : UIView = transitionContext.containerView
        let toView : UIView = toVC.view
        containerView.addSubview(toView)
        self.confirmShowAnimation(transitionContext)
    }
    
    private func confirmShowAnimation(_ transitionContext : UIViewControllerContextTransitioning){
        
        UIView.setAnimationCurve(.easeInOut)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { [weak self] in
            self?.backButton.frame = CGRect(x: (DeviceWidth() - 80)/2 - 64, y: DeviceHeight() - 112, width: 80, height: 80)
            self?.confirmButton.frame = CGRect(x: (DeviceWidth() - 80)/2 + 64, y: DeviceHeight() - 112, width: 80, height: 80)
        }) { (finish) in
            transitionContext.completeTransition(true)
        }
    }
    
}

extension ZLPhotoPreviewViewController : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
