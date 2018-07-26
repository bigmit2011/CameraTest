//
//  ViewController.swift
//  Fish
//
//  Created by Amit on 7/9/18.
//  Copyright © 2018 Amit. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController :UIViewController {
    
    func applyRoundCorner(_ object: AnyObject){
        object.layer.cornerRadius = (object.frame.size.width)/2
        object.layer.masksToBounds = true
    }
    
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBAction func Library(_ sender: Any) {
    }
    

    @IBAction func FlipCamera(_ sender: Any) {
        captureSession.stopRunning()
        cameraPreviewlayer?.removeFromSuperlayer()
        //cameraPreviewlayer = nil
        //self.captureSession = nil
        
        setupCaptureSession()
        if currentCamera! == backCamera{
            //print(currentCamera)
            currentCamera = frontCamera}
        else {
            currentCamera = backCamera}
        setupCaptureSession()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
    }
    
    
   var captureSession = AVCaptureSession()
   var backCamera: AVCaptureDevice?
   var frontCamera: AVCaptureDevice?
   var currentCamera: AVCaptureDevice?
   var cameraPreviewlayer: AVCaptureVideoPreviewLayer?
   var photoOutput: AVCapturePhotoOutput?
   var image: UIImage?
    
    
   override func viewDidLoad() {
    super.viewDidLoad()
    
    self.applyRoundCorner(cameraButton)
    setupCaptureSession()
    setupInputOutput()
    setupPreviewLayer()
    startRunningCaptureSession()
   
    
    }

  
    
   func setupCaptureSession(){
       captureSession.sessionPreset = AVCaptureSession.Preset.photo // Why exclamation point?
       let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
       let devices = availableDevice.devices //back or front
        
        
       for device in devices {
            
           if device.position == AVCaptureDevice.Position.back{
                backCamera = device
           }else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
            }
    currentCamera = backCamera
        }
    
    
   func setupInputOutput(){
       do {
           let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
           captureSession.addInput(captureDeviceInput)
           photoOutput = AVCapturePhotoOutput()
           photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
           captureSession.addOutput(photoOutput!)
           }
       catch{
           print(error)
            
        }
    }
    
    func setupPreviewLayer(){
        cameraPreviewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewlayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewlayer?.frame = self.imagePreview.frame
        self.view.layer.insertSublayer(cameraPreviewlayer!, at: 0)
    }
        
    func startRunningCaptureSession(){
            captureSession.startRunning()
        }


    @IBAction func TakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
                }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showPhotoSegue"{
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
    }
}

}
    extension CameraViewController: AVCapturePhotoCaptureDelegate{
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(){
                image = UIImage(data: imageData)
                performSegue(withIdentifier:"showPhotoSegue", sender: nil)        }
    }


    

}



