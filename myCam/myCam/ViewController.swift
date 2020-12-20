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

    var lay :AVCaptureVideoPreviewLayer!
    @IBOutlet weak var fillterControl: UISegmentedControl!

    var filters: Filters!
    var input : AVCaptureDeviceInput!
    var session: AVCaptureSession!
    var lay: AVCaptureVideoPreviewLayer!
    
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

    @objc func switchFillter (_ segmentControl : UISegmentedControl){
        
        switch segmentControl.selectedSegmentIndex{
        
        case 0 :
            filters.textLayer.removeFromSuperlayer()
//            filters.emitter.removeFromSuperlayer()

            filters.filter_lama(to: lay, videoSize: lay.frame.size)
            
        case 1 :
//            filters.emitter.removeFromSuperlayer()
            filters.imageLayer.removeFromSuperlayer()
            
            filters.filter_hanan(text: "Hello, World!", to: lay, videoSize: lay.frame.size)
        
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillterControl.addTarget(self, action: #selector(switchFillter), for: .touchUpInside)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.lay = AVCaptureVideoPreviewLayer(session:self.session)

        self.lay.frame = previewView.frame
        self.lay.videoGravity = .resizeAspectFill
        
        self.previewView.layer.addSublayer(lay)

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
    
    @IBAction func fillterModeChange(_ sender: UISegmentedControl) {
        switch fillterControl.selectedSegmentIndex {
        case 0:
            filters.emitter?.removeFromSuperlayer()
            filters.textLayer2?.removeFromSuperlayer()
            filters.imageLayer1?.removeFromSuperlayer()
            filters.imageLayer2?.removeFromSuperlayer()
            
            filters.textLayer?.removeFromSuperlayer()
            filters.imageLayer.removeFromSuperlayer()
        case 1:
            filters.emitter?.removeFromSuperlayer()
            filters.textLayer2?.removeFromSuperlayer()
               filters.imageLayer1?.removeFromSuperlayer()
               filters.imageLayer2?.removeFromSuperlayer()
            filters.textLayer?.removeFromSuperlayer()
            filters.imageLayer1?.removeFromSuperlayer()
            filters.filter_lama( to: lay, videoSize: lay.frame.size)
        
        case 2 :
            filters.emitter?.removeFromSuperlayer()
            filters.textLayer2?.removeFromSuperlayer()
               filters.imageLayer1?.removeFromSuperlayer()
               filters.imageLayer2?.removeFromSuperlayer()
            filters.imageLayer?.removeFromSuperlayer()
           
            filters.filter_hanan(text: "welcome", to: lay, videoSize: lay.frame.size)
            filters.addConfetti(to: lay)
        
        case 3:
            filters.emitter?.removeFromSuperlayer()
            filters.textLayer2?.removeFromSuperlayer()
            filters.imageLayer1?.removeFromSuperlayer()
            filters.imageLayer2?.removeFromSuperlayer()
            filters.textLayer?.removeFromSuperlayer()
            filters.imageLayer?.removeFromSuperlayer()
            
            filters.filter_ashwaq(text: "Hello 2021 ", to: lay, videoSize: lay.frame.size)
        default:
            break
        }
    }

}
