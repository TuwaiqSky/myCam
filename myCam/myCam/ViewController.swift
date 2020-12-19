//
//  ViewController.swift
//  myCam
//
//  Created by Hanan on 19/12/2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
   
    var session: AVCaptureSession!
    
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
    }
    
}

