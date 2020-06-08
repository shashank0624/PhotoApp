//
//  ViewController.swift
//  PhotoApp
//
//  Created by Kirti Ahlawat on 06/06/20.
//  Copyright © 2020 Outect. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    
    let captureSession = AVCaptureSession()
    var previewLayer : CALayer!
    
    var captureDevice : AVCaptureDevice!
    
    var takePhoto = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        prepareCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopCaptureSession()
    }
    
    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        captureDevice = availableDevices.first
        beginSession()
        
    }
    
    func beginSession(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        }catch{
            print("Handling Error : \(error.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String) : NSNumber(value: kCVPixelFormatType_32BGRA)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput){
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.outect.photoQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
    }
    
    func navigateToCameraVC(){
        performSegue(withIdentifier: "cameraToPreviewVC", sender: nil)
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        takePhoto = true
    }
    
}

extension CameraVC : AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto{
            takePhoto.toggle()
            if let image = getImageFrom(sampleBuffer: sampleBuffer){
                DispatchQueue.main.async {
                    if #available(iOS 13.0, *) {
                        if let previewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PreviewVC") as? PreviewVC{
                            previewVC.capturedImage = image
                            self.navigationController?.pushViewController(previewVC, animated: true)
//                            self.present(previewVC, animated: true) {
//                                self.stopCaptureSession()
//                            }
                        }
                    } else {
                        if let previewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreviewVC") as? PreviewVC{
                            previewVC.capturedImage = image
                            previewVC.capturedImage = image
                            self.navigationController?.pushViewController(previewVC, animated: true)
//                            self.present(previewVC, animated: true) {
//                                self.stopCaptureSession()
//                            }
                        }
                    }
                }
            }
        }
    }
    
    func getImageFrom(sampleBuffer buffer : CMSampleBuffer) -> UIImage?{
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer){
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            if let image = context.createCGImage(ciImage, from: imageRect){
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    
    func stopCaptureSession(){
        self.captureSession.stopRunning()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput]{
            for input in inputs{
                self.captureSession.removeInput(input)
            }
        }
    }
}
