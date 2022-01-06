//
//  IdentifikasiViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit
import AVFoundation

class IdentifikasiViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    
 
    
    //Label
    @IBOutlet weak var fotoLabel: UILabel!
    
    //Button
    
    
    
    @IBAction func shutterButton(_ sender: UIButton) {
        
        let settings = AVCapturePhotoSettings()
        imageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction func flipButton(_ sender: UIButton) {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        
        //CameraDevice
        if index == 0{
            index = 1
        } else {
            index = 0
        }
        
        if index == 1{
            currentCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)!
            
        } else {
            currentCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
        }
        
        //InputCameraDevice
        do {
            let input = try AVCaptureDeviceInput(device: currentCamera)

            imageOutput = AVCapturePhotoOutput()

            //AttachOutput&Input
            if captureSession.canAddInput(input) && captureSession.canAddOutput(imageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(imageOutput)
                setupPreviewLayer()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
         }
    }
    
    
    //CameraCapture
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imageCapture: UIImageView!
    
    var result = ResultPageViewController()
    var captureSession: AVCaptureSession!
    var imageOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var currentCamera: AVCaptureDevice = AVCaptureDevice.default(for: .video)!
    var usingFrontCamera = false
    var index = 0
    var flashMode: AVCaptureDevice.FlashMode = .auto

    //PrivacyAccessCamera
    class func requestAccess(for mediaType: AVMediaType,
                             completionHandler handler: @escaping (Bool) -> Void){
        
    }
    
    
    //SetupFlash
    func flashOn(currentCamera: AVCaptureDevice)
    {
        do{
            if(currentCamera.hasFlash)
            {
                try currentCamera.lockForConfiguration()
                currentCamera.torchMode = .on
                currentCamera.flashMode = .on
                currentCamera.unlockForConfiguration()
            }
            
        }
        catch{
            print("Flash Error")
        }
    }
    
    func flashOff(currentCamera:AVCaptureDevice)
        {
            do{
                if (currentCamera.hasFlash){
                    try currentCamera.lockForConfiguration()
                    currentCamera.torchMode = .off
                    currentCamera.flashMode = .off
                    currentCamera.unlockForConfiguration()
                }
            }catch{
                //DISABEL FLASH BUTTON HERE IF ERROR
                print("Device tourch Flash Error ");
            }
        }
    
    @objc func toggleFlash(){
        if #available(iOS 10.0, *) {
                    
                let videoDeviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDuoCamera], mediaType: .video, position: .unspecified)
                
                let devices = videoDeviceSession.devices
                    currentCamera = devices.first!

                } else {
                    // Fallback on earlier versions
                    currentCamera = AVCaptureDevice.default(for: .video)!
                }

        if ((currentCamera as AnyObject).hasMediaType(AVMediaType.video))
                {
                    if (currentCamera.hasTorch)
                    {
                        self.captureSession.beginConfiguration()
                        //self.objOverlayView.disableCenterCameraBtn();
                        if currentCamera.isTorchActive == false {
                            self.flashOn(currentCamera: currentCamera)
                        } else {
                            self.flashOff(currentCamera: currentCamera);
                        }
                        //self.objOverlayView.enableCenterCameraBtn();
                        self.captureSession.commitConfiguration()
                    }
                }
    }
    
    
    //CaptureProcess
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        imageCapture.image = image
        
        //PassingPhoto
        ImageModel.shared.image = image
        let vc = ResultPageViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //CleanUpSession
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //NavBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(toggleFlash))
        
        //HideTabBar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        //CameraDevice
        currentCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
        
        //InputCameraDevice
        do {
            let input = try AVCaptureDeviceInput(device: currentCamera)

            imageOutput = AVCapturePhotoOutput()

            //AttachOutput&Input
            if captureSession.canAddInput(input) && captureSession.canAddOutput(imageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(imageOutput)
                setupPreviewLayer()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }

    }
    
    //SetupCameraLayer
    func setupPreviewLayer() {
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(previewLayer)
        
        //StartCameraView
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            
            //cameraViewSize = previewLayerSize
            DispatchQueue.main.async {
                self.previewLayer.frame = self.cameraView.bounds
            
            }
        }
        
    }

}
