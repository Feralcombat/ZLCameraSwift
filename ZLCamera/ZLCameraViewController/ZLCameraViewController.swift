//
//  ZLCameraViewController.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/11.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class ZLCameraViewController: UIViewController {
    
    private var videoDevice : AVCaptureDevice? = nil
    private var audioDevice : AVCaptureDevice? = nil
    private var videoInput : AVCaptureDeviceInput? = nil
    private var audioInput : AVCaptureDeviceInput? = nil
    private var imageOutput : AVCaptureStillImageOutput? = nil
    private var movieOutput : AVCaptureMovieFileOutput? = nil
    private var session : AVCaptureSession? = nil
    private var previewLayer : AVCaptureVideoPreviewLayer? = nil
    private let switchButton : UIButton = UIButton(type: .custom)
    private let backButton : UIButton = UIButton(type: .custom)
    private let snapButton : ZLBlurButton = ZLBlurButton(effect: UIBlurEffect(style: .light))
    
    private var setupComlete : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupCamera { (completion) in
            if (completion){
                self.setupComlete = true
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.setupComlete {
            self.startSession()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func record(_ state: String){
        if state == "began" {
            print("began")
        }
        else if state == "ended"{
            print("ended")
        }
    }
    
    @objc private func snapShot(_ : UIButton){
        self.imageOutput?.captureStillImageAsynchronously(from: (self.imageOutput?.connection(with: .video))!, completionHandler: { (buffer, error) in
            if error != nil {return}
            
            if buffer != nil{
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    let previewVC = ZLPhotoPreviewViewController()
                    previewVC.image = image
                    self.present(previewVC, animated: true, completion: nil)
                }
            }
                
        })
    }
    
    @objc private func switchCameraPosition(_ : UIButton){
        if self.videoDevice?.position == .back {
            if self.isFrontCameraAvailable(){
                self.session?.beginConfiguration()
                self.session?.removeInput(self.videoInput!)
                
                for device in AVCaptureDevice.devices(for: .video){
                    if device.position == .front{
                        self.videoDevice = device
                        break;
                    }
                }
                self.videoInput = try? AVCaptureDeviceInput(device: self.videoDevice!)
                
                if (self.session?.canAddInput(self.videoInput!))!{
                    self.session?.addInput(self.videoInput!)
                }
                
                self.session?.commitConfiguration()
            }
        }
        else{
            if self.isRearCameraAvailable(){
                self.session?.beginConfiguration()
                self.session?.removeInput(self.videoInput!)
                
                for device in AVCaptureDevice.devices(for: .video){
                    if device.position == .back{
                        self.videoDevice = device
                        break;
                    }
                }
                self.videoInput = try? AVCaptureDeviceInput(device: self.videoDevice!)
                
                if (self.session?.canAddInput(self.videoInput!))!{
                    self.session?.addInput(self.videoInput!)
                }
                
                self.session?.commitConfiguration()
            }
        }
    }
    
    @objc private func backButton_pressed(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadUI(){
        self.view.backgroundColor = UIColor.black
        
        self.backButton.setImage(UIImage(named: "photo_icon_hide"), for: .normal)
        self.backButton.addTarget(self, action: #selector(backButton_pressed(_:)), for: .touchUpInside)
        self.view.addSubview(self.backButton)
        
        self.switchButton.setImage(UIImage(named: "photo_icon_cut"), for: .normal)
        self.switchButton.addTarget(self, action: #selector(switchCameraPosition(_:)), for: .touchUpInside)
        self.view.addSubview(self.switchButton)
        
        self.snapButton.circleView.layer.cornerRadius = 30
        self.snapButton.circleView.layer.masksToBounds = true
        self.snapButton.layer.cornerRadius = 40
        self.snapButton.layer.masksToBounds = true
        self.snapButton.addTarget(target: self, selector: #selector(snapShot(_:)), type: .tap)
        self.snapButton.addTarget(target: self, selector: #selector(record(_:)), type: .longPress)
        self.view.addSubview(self.snapButton)

        
        self.backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snapButton)
            make.right.equalTo(self.snapButton.snp.left).offset(-48)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        self.switchButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(16)
            make.right.equalTo(self.view).offset(-12)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
        
        self.snapButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-24)
            make.width.equalTo(80)
            make.height.equalTo(80)
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

// MARK: - 相机配置
extension ZLCameraViewController{
    private func isRearCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
    private func isFrontCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(.front)
    }
    
    private func setupCamera(compeltion: @escaping (_  : Bool) -> Void){
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.videoDevice = AVCaptureDevice.default(for: .video)
            self?.audioDevice = AVCaptureDevice.default(for: .audio)
            
            self?.videoInput = try? AVCaptureDeviceInput.init(device: (self?.videoDevice!)!)
            self?.audioInput = try? AVCaptureDeviceInput.init(device: (self?.audioDevice!)!)
            
            self?.imageOutput = AVCaptureStillImageOutput()
            self?.movieOutput = AVCaptureMovieFileOutput()
            
            self?.session = AVCaptureSession()
            self?.session?.canSetSessionPreset(.high)
            
            if (self?.session?.canAddInput((self?.videoInput!)!))!{
                self?.session?.addInput((self?.videoInput!)!)
            }
            
            if (self?.session?.canAddInput((self?.audioInput!)!))!{
                self?.session?.addInput((self?.audioInput!)!)
            }
            
            if (self?.session?.canAddOutput((self?.imageOutput!)!))!{
                self?.session?.addOutput((self?.imageOutput!)!)
            }
            
            if (self?.session?.canAddOutput((self?.movieOutput!)!))!{
                self?.session?.addOutput((self?.movieOutput!)!)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.previewLayer = AVCaptureVideoPreviewLayer(session: (self?.session!)!)
                self?.previewLayer?.videoGravity = .resizeAspectFill
                
                self?.previewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                self?.view.layer.addSublayer((self?.previewLayer!)!)
                
                self?.loadUI()
                compeltion(true)
            }
        }
    }
}

// MARK: - 一些方法
extension ZLCameraViewController{
    private func startSession(){
        if !(self.session?.isRunning)! {
            self.session?.startRunning()
        }
    }
    
    private func stopSession(){
        if (self.session?.isRunning)! {
            self.session?.stopRunning()
        }
    }
    
    private func configAuthorization(){
        let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .denied || authStatus == .restricted {
            let alert = UIAlertView(title: "没有相机权限", message: "请去设置-隐私-相机中对应用授权", delegate: self, cancelButtonTitle: "好的");
            alert.show()
        }
    }
}

extension ZLCameraViewController : UIAlertViewDelegate{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let url : URL! = URL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}

