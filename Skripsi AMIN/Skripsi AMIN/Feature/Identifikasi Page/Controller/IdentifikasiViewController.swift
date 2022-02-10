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
        
        //ButtonAnimation
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: CGFloat(0.20), initialSpringVelocity: CGFloat(6.0), options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    sender.transform = CGAffineTransform.identity
                }, completion: {Void in()})
        
        let settings = getSettings(camera: currentCamera, flashMode: flashMode)
        //let settings = AVCapturePhotoSettings()
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
    var flashModeCamera: Bool = true
    var flashMode: AVCaptureDevice.FlashMode = .auto

    //PrivacyAccessCamera
    class func requestAccess(for mediaType: AVMediaType,
                             completionHandler handler: @escaping (Bool) -> Void){
        
    }
    
    private func getSettings(camera: AVCaptureDevice, flashMode: AVCaptureDevice.FlashMode) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()

        if camera.hasFlash {
            settings.flashMode = flashMode
        }
        return settings
    }
    
    @objc func flashOnOff(){
            if flashModeCamera == false{
                flashModeCamera = true
                navigationItem.leftBarButtonItem?.image = UIImage(systemName: "bolt.fill")
                flashMode = .on
                print("on")
            }else{
                flashModeCamera = false
                navigationItem.leftBarButtonItem?.image = UIImage(systemName: "bolt.slash.fill")
                flashMode = .off
                print("off")
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
        vc.modalPresentationStyle = .fullScreen
        //self.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Kembali", style: .plain, target: nil, action: nil)
    }
    
    //CleanUpSession
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //NavBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bolt.badge.a.fill"), style: .plain, target: self, action: #selector(flashOnOff))
        
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
