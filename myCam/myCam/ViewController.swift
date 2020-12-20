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
    
    //MARK: views
    @IBOutlet var topView: UIView!
    @IBOutlet var previewView: UIView!
    
    //MARK: buttons
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var switchButton: UIButton!
    
    //MARK: segmented control
    @IBOutlet var fillterControl: UISegmentedControl!
    
    //MARK: images
    var previewImage: UIImage!
    
    //MARK: AVCapture instances
    var session: AVCaptureSession!
    var input : AVCaptureDeviceInput!
    var lay: AVCaptureVideoPreviewLayer!
    
    //MARK: filters class instance
    var filters: Filters!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.filters = Filters()
        
        // set title for switchButton
        switchButton.setTitle("back", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fillterControl.addTarget(self, action: #selector(switchFillter), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.session = AVCaptureSession()
        
        // camera setup
        setupInputDevice()
        setupViedoPreview()
        setupSessionConfig()
        
    }
    
    //MARK:  Access camera device, set camera device as input
    func setupInputDevice() {
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
    
    //MARK: set up video preview layer
    func setupViedoPreview() {
        self.lay = AVCaptureVideoPreviewLayer(session:self.session)
        self.previewView.layer.insertSublayer(lay, below: topView.layer)

        lay.frame = view.frame
        lay.videoGravity = .resizeAspectFill
    }
    
    func setupSessionConfig(){
        DispatchQueue.global(qos: .userInitiated).async {
            //MARK: start config
            self.session.beginConfiguration()
            
            // confiugration
            guard self.session.canSetSessionPreset(self.session.sessionPreset) else { return }
            self.session.sessionPreset = .photo
            
            self.session.automaticallyConfiguresCaptureDeviceForWideColor = true
          
            let output = AVCapturePhotoOutput()
            
            guard self.session.canAddOutput(output) else { return }
            self.session.addOutput(output)
            
            //MARK: commit config
            self.session.commitConfiguration()
            
            // run session
            self.session.startRunning()
        }
    }
    
    //MARK: swich camera input
    @IBAction func flipCam(_ sender: UIButton) {
        session.removeInput(input)
        
        setupInputDevice()
    }
    
    //MARK: capture still photo
    @IBAction func capturePhoto(_ sender: UIButton) {
        guard let output = self.session.outputs[0] as? AVCapturePhotoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        
        settings.embeddedThumbnailPhotoFormat = [
            AVVideoCodecKey : AVVideoCodecType.jpeg ]
        
        output.capturePhoto(with: settings, delegate: self)
    }
    
    //MARK: Save captured photo into user's PhotoLibrary
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
    
    //MARK: swich between filters
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
