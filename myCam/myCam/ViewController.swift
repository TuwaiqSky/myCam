//
//  ViewController.swift
//  myCam
//
//  Created by Hanan on 19/12/2020.
//

import UIKit
import AVFoundation
import Photos
class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
   
    var session: AVCaptureSession!
    var previewImage: UIImage!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.session = AVCaptureSession()
        
        guard let cam = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device:cam) else { return
        }
    
        self.session.addInput(input)
        
        let lay = AVCaptureVideoPreviewLayer(session:self.session)
        lay.frame = view.frame
        self.view.layer.addSublayer(lay)
        
        self.session.startRunning()
        
        
        self.session.beginConfiguration()
        
        guard self.session.canSetSessionPreset(self.session.sessionPreset) else {return}
        
        self.session.sessionPreset = .photo
        let output = AVCapturePhotoOutput()
        guard self.session.canAddOutput(output) else {return}
        self.session.addOutput(output)
        self.session.commitConfiguration()
        
    }        
    
    @IBAction func cameraPressed(_ sender: Any) {
        guard let output = self.session.outputs[0] as? AVCapturePhotoOutput else {return}
            let settings = AVCapturePhotoSettings()

        
        let pbpf = settings.availablePreviewPhotoPixelFormatTypes[0]
        let len = view.frame
            
            settings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String : pbpf,
                kCVPixelBufferWidthKey as String : len,
                kCVPixelBufferHeightKey as String : len
        ]
        
        settings.embeddedThumbnailPhotoFormat =
            [ AVVideoCodecKey : AVVideoCodecType.jpeg
            ]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let cgim = photo.previewCGImageRepresentation()?.takeUnretainedValue() {
        let orient =  UIImage.Orientation.right
        self.previewImage = UIImage(cgImage: cgim, scale: 1, orientation: orient)
        }
        if let data = photo.fileDataRepresentation() {
        let lib = PHPhotoLibrary.shared()
            lib.performChanges {
        let req = PHAssetCreationRequest.forAsset()
        req.addResource(with: .photo, data: data, options: nil) }
        }
    }
    
}

