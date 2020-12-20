//
//  ViewController.swift
//  myCam
//
//  Created by Hanan on 19/12/2020.
//

import UIKit
import Photos
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // views
    @IBOutlet var topView: UIView!
    @IBOutlet var previewView: UIView!
    
    // buttons
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var switchButton: UIButton!
    
    // segmented control
    @IBOutlet var fillterControl: UISegmentedControl!
    
    // images
    var previewImage: UIImage!
    
    // AVCapture instances
    var session: AVCaptureSession!
    var input : AVCaptureDeviceInput!
    var lay: AVCaptureVideoPreviewLayer!
    
    // filters class instance
    var filters: Filters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.session = AVCaptureSession()
        self.filters = Filters()
        
        // set title for switchButton
        switchButton.setTitle("front", for: .normal)
        
        //  Access camera device, set camera device as input
        addInputDevice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillterControl.addTarget(self, action: #selector(switchFillter), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set up video preview layer
        self.lay = AVCaptureVideoPreviewLayer(session:self.session)
        lay.frame = previewView.frame
        lay.videoGravity = .resizeAspectFill
        self.previewView.layer.addSublayer(lay)
        
        self.session.startRunning()
        
        //  configure capture session
        self.session.beginConfiguration()
        
        guard self.session.canSetSessionPreset(self.session.sessionPreset) else {
            return }
        
        self.session.sessionPreset = .photo
        
        // configure output as photo output
        let output = AVCapturePhotoOutput()
        
        guard self.session.canAddOutput(output) else {
            return }
        
        self.session.addOutput(output)
        self.session.commitConfiguration()
    }
    
    // device input -> front camera | back camera
    func addInputDevice() {
        if switchButton.currentTitle == "front" {
            switchButton.setTitle("back", for: .normal)
            
            guard let cam = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: AVMediaType.video,
                                                    position: .front),
                  let inp = try? AVCaptureDeviceInput(device: cam) else {
                print("Unable to access back camera!")
                return }
            
            self.input = inp
            self.session.addInput(input)
            
        } else if switchButton.currentTitle == "back" {
            switchButton.setTitle("front", for: .normal)
            
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
    
    // swich camera input
    @IBAction func flipCam(_ sender: UIButton) {
        session.removeInput(input)
        
        addInputDevice()
    }
    
    //  Capture still photo
    @IBAction func capturePhoto(_ sender: UIButton) {
        guard let output = self.session.outputs[0] as? AVCapturePhotoOutput else {
            return }
        
        let settings = AVCapturePhotoSettings()
        
        settings.embeddedThumbnailPhotoFormat = [
            AVVideoCodecKey : AVVideoCodecType.jpeg ]
        
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
    
    // swich between filters
    @objc func switchFillter (_ segmentControl : UISegmentedControl){
        
        switch segmentControl.selectedSegmentIndex{
        
        case 0 :
            filters.textLayer.removeFromSuperlayer()
            //            filters.emitter.removeFromSuperlayer()
            
            filters.addFireworksImage(to: lay, videoSize: lay.frame.size)
            
        case 1 :
            //            filters.emitter.removeFromSuperlayer()
            filters.imageLayer.removeFromSuperlayer()
            
            filters.addTextFilter(text: "Hello, World!", to: lay, videoSize: lay.frame.size)
            
        default:
            break
        }
    }
}









