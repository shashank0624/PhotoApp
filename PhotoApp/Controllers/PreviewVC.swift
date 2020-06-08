//
//  PreviewVC.swift
//  PhotoApp
//
//  Created by Kirti Ahlawat on 06/06/20.
//  Copyright © 2020 Outect. All rights reserved.
//

import UIKit

class PreviewVC: UIViewController {
    var capturedImage : UIImage?

    @IBOutlet weak var capturedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        updateNavigationControllers()
        guard let captureImage = capturedImage else {return}
        capturedImageView.image = captureImage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationControllers()
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func updateNavigationControllers(){
        guard let navigationController = navigationController else {return}
        if !navigationController.hasViewController(ofKind: CameraVC.self){
            let loginVC = AppDelegate.getMainStoryboard().instantiateViewController(withIdentifier: "CameraVC")
            navigationController.viewControllers.insert(loginVC, at: 0)
        }
    }
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        guard let captureImage = capturedImage else {return}
        UIImageWriteToSavedPhotosAlbum(captureImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        capturedImage = nil
        deleteUserDefaultValues()
        if let navController = navigationController{
            navController.popToRootViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func deleteUserDefaultValues(){
        let savedata =  UserDefaults.init(suiteName: "group.com.outect.photoApp")
        if savedata?.value(forKey: "img") != nil {
            savedata?.set(nil, forKey: "img")
        }
    }
    
    
    @objc func image(_ image : UIImage, didFinishSavingWithError err : Error?, contextInfo : UnsafeRawPointer){
        if let err = err{
            print("Error : \(err.localizedDescription)")
        }else{
            NotificationPublisher.shared.sendNotifications(withIdentifier: "File Save Notification", title: "Saved", subTitle: "", body: "Image Successfully Saved In Photos", delayInterval: 1, badge: nil)
            print("Image Successfully Saved")
        }
    }
    

}
