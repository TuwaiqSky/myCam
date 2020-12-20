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
    
    @IBOutlet var topView: UIView!
    @IBOutlet var previewView: UIView!
    
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var switchButton: UIButton!
    
    var filters: Filters!
    var input : AVCaptureDeviceInput!
    var session: AVCaptureSession!
    var previewImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.session = AVCaptureSession()
        self.filters = Filters()
        
        switchButton.setTitle("front", for: .normal)
        
        //  Access front camera device
        guard let cam = AVCaptureDevice.default(.builtInDualCamera,
                                                for: AVMediaType.video,
                                                position: .back),
              let inp = try? AVCaptureDeviceInput(device: cam) else {
            print("Unable to access back camera!")
            return }
        
        self.input = inp
        
        //  set camera device as input
        self.session.addInput(input)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lay = AVCaptureVideoPreviewLayer(session:self.session)
        lay.frame = previewView.frame
        lay.videoGravity = .resizeAspectFill
        
        self.previewView.layer.addSublayer(lay)
        
        filters.filter_lama(text: " Hello world!!", to: lay, videoSize: lay.frame.size)
        
        self.session.startRunning()
        
        //  configure capture session
        self.session.beginConfiguration()
        
        guard self.session.canSetSessionPreset(self.session.sessionPreset) else {
            return }
        
        self.session.sessionPreset = .photo
        let output = AVCapturePhotoOutput()
        guard self.session.canAddOutput(output) else {
            return }
        
        self.session.addOutput(output)
        self.session.commitConfiguration()
    }
    
    
    //  Capture still photo
    @IBAction func capturePhoto(_ sender: UIButton) {
        guard let output = self.session.outputs[0] as? AVCapturePhotoOutput else {
            return }
        
        let settings = AVCapturePhotoSettings()
        
        settings.embeddedThumbnailPhotoFormat = [
            AVVideoCodecKey : AVVideoCodecType.jpeg
        ]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    // Save captured photo into user's PhotoLibrary
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
    
    // swich camera input
    @IBAction func flipCam(_ sender: UIButton) {
        session.removeInput(input)
        
        if sender.currentTitle == "front" {
            sender.setTitle("back", for: .normal)
            
            guard let cam = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: AVMediaType.video,
                                                    position: .front),
                  let inp = try? AVCaptureDeviceInput(device: cam) else {
                print("Unable to access back camera!")
                return }
            
            self.input = inp
            self.session.addInput(input)
            
        } else if sender.currentTitle == "back" {
            sender.setTitle("front", for: .normal)
            
            guard let cam = AVCaptureDevice.default(.builtInDualCamera,
                                                    for: AVMediaType.video,
                                                    position: .back),
                  let inp = try? AVCaptureDeviceInput(device: cam) else {
                print("Unable to access back camera!")
                return }
            
            self.input = inp
            self.session.addInput(input)
        }
    }
    
}









