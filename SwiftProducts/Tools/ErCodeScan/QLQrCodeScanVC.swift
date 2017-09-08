//
//  QLQrCodeScanVC.swift
//  QTimelyLoan
//
//  Created by Jingnan Zhang on 16/9/14.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//  二维码扫描控制器

import UIKit
import Photos
import AssetsLibrary
import AVFoundation

class QLQrCodeScanVC: UIViewController, QLQrCodeScanViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var qrCodeScanView:QLQrCodeScanView!
    private var image:UIImage!
//    private var isFirstComeIn = true // 是否首次进入此页
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫码认证"
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "相册", style: .Plain, target: self, action: #selector(gotoAlbum))

        qrCodeScanView = QLQrCodeScanView.init(withSuperView: self.view)
        qrCodeScanView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 说明进入相册后未选择照片, 首次进入此控制器若调用qrCodeScanView.start()则会崩溃的
//        if (image == nil) && (isFirstComeIn == false)
//        {
//            
//        }
        qrCodeScanView.start() // 继续扫描即可
        
        
    }
    
    // 防止滑动但未返回的情况
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        qrCodeScanView.stop()
    }
    
    // MARK: 去相册
    func gotoAlbum()  {
        if isGetPhotoAccess() {
            let picker = UIImagePickerController()
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: {
//                self.isFirstComeIn = false
            })
            
        }else{
            Config.showAlert(withMessage: "无相册权限！")
        }
        
        
    }
    
    //MARK: ----获取相册权限
    private func isGetPhotoAccess()->Bool{
        var result = false
        if  Float(UIDevice.currentDevice().systemVersion) < 8.0{
            if( ALAssetsLibrary.authorizationStatus() != ALAuthorizationStatus.Denied ){
                result = true
            }
        }else{
            if ( PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Denied ){
                result = true
            }
        }
        return result
    }
    
    // MARK: QLQrCodeScanViewDelegate
    func finishScanQrCodeWithOutPutString(result: String) {
//        lab1.text = "点击继续"
        // 测试
        Config.showAlert(withMessage: result)
        debugPrint(result)
        setPreAppCodeForScanResult(result)
    }
    
    // MARK: ------  UIImagePickerControllerDelegate -----
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
        
        // 关闭相册页
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        //获取选择的原图
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 从所选中的图片中读取二维码
        guard let ciImage  = CIImage(image:image) else{
            debugPrint("无法获取到已选择的图片")
            return
        }
        
        // 探测器
        let context = CIContext.init(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
        let features = detector.featuresInImage(ciImage)
        
        if features.count == 0 {
            Config.showAlert(withMessage: "没有读取到二维码！")
//            image = nil
        }
        
        //遍历所有的二维码  && 取出探测到的数据
        for feature in features {
            let qrCodeFeature = feature as! CIQRCodeFeature
            // 测试

            setPreAppCodeForScanResult(qrCodeFeature.messageString)
            
        }
        
       
        
    }
    
    func setPreAppCodeForScanResult(resultString: String)
    {
        let resultVC = QrCodeScanResultVC.viewController
        resultVC.preAppCodeString = resultString
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    
}
