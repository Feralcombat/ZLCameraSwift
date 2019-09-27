//
//  ZLCameraViewController.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/15.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit

@objc protocol ZLCameraViewControllerDelegate{
    @objc optional func cameraViewControllerDidDismiss(_ cameraViewController: ZLCameraViewController)
    @objc optional func cameraViewController(_ cameraViewController: ZLCameraViewController, didFinishPick image : UIImage)
    @objc optional func cameraViewController(_ cameraViewController: ZLCameraViewController, didFinishPickVideo url : URL)
}

class ZLCameraViewController: UINavigationController {
    weak var cameraDelegate : ZLCameraViewControllerDelegate? = nil
    
    convenience init(delegate : ZLCameraViewControllerDelegate?) {
        let rootVC = ZLCaptureViewController()
        self.init(rootViewController: rootVC)
        self.modalPresentationStyle = .fullScreen;
        self.cameraDelegate = delegate
        rootVC.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ZLCameraViewController : ZLCaptureViewControllerDelegate{
    func captureViewControllerDidDismiss(_ captureViewController: ZLCaptureViewController) {
        self.cameraDelegate?.cameraViewControllerDidDismiss?(self)
    }
    
    func captureViewController(_ captureViewController: ZLCaptureViewController, didFinishPick image: UIImage) {
        self.cameraDelegate?.cameraViewController?(self, didFinishPick: image)
    }
    
    func captureViewController(_ captureViewController: ZLCaptureViewController, didFinishPickVideo url: URL) {
        self.cameraDelegate?.cameraViewController?(self, didFinishPickVideo: url)
    }
    
}

extension ZLCameraViewController : UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
            case .none:
                return nil
            case .push:
                return toVC as? UIViewControllerAnimatedTransitioning
            case .pop:
                return fromVC as? UIViewControllerAnimatedTransitioning
        }
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
