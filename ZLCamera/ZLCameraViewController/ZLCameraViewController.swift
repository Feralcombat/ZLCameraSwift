//
//  ZLCameraViewController.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/15.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit

class ZLCameraViewController: UINavigationController {

    convenience init() {
        let rootVC = ZLCaptureViewController()
        self.init(rootViewController: rootVC)
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
