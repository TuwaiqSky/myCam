//
//  Filters.swift
//  myCam
//
//  Created by Hanan on 19/12/2020.
//

import UIKit
import AVFoundation

class Filters {
    var textLayer: CATextLayer!
    
    func filter_hanan (text: String, to layer: CALayer, videoSize: CGSize) {
        
        
        
        let image = UIImage(named: "fireworks")!
              let imageLayer = CALayer()
              
        let aspect: CGFloat = image.size.width / image.size.height
              let width = videoSize.width
              let height = width / aspect
              imageLayer.frame = CGRect(
                x: 0,
                y: height * 0.80,
                width: width,
                height: height)
              
              imageLayer.contents = image.cgImage
              layer.addSublayer(imageLayer)
        
        
        let animate = CABasicAnimation(keyPath: "transform.scale")
        animate.fromValue = 0.8
        animate.toValue = 1.2
        animate.duration = 0.5
        animate.repeatCount = .greatestFiniteMagnitude
        animate.autoreverses = true
        animate.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        animate.beginTime = AVCoreAnimationBeginTimeAtZero
        animate.isRemovedOnCompletion = false
        imageLayer.add(animate, forKey: "scale")
        
        layer.addSublayer(imageLayer)
        
        
    
          let attributedText = NSAttributedString(
            string: text,
            attributes: [
              .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
                .foregroundColor: UIColor.green ,
              .strokeColor: UIColor.white,
              .strokeWidth: -3])
          
          textLayer = CATextLayer()
          textLayer.string = attributedText
          textLayer.shouldRasterize = true
          textLayer.rasterizationScale = UIScreen.main.scale
          textLayer.backgroundColor = UIColor.clear.cgColor
          textLayer.alignmentMode = .center
          
          textLayer.frame = CGRect(
            x: 0,
            y: videoSize.height * 0.66,
            width: videoSize.width,
            height: 150)
          textLayer.displayIfNeeded()
          
          let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
          scaleAnimation.fromValue = 0.8
          scaleAnimation.toValue = 1.2
          scaleAnimation.duration = 0.5
          scaleAnimation.repeatCount = .greatestFiniteMagnitude
          scaleAnimation.autoreverses = true
          scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
          
          scaleAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
          scaleAnimation.isRemovedOnCompletion = false
          textLayer.add(scaleAnimation, forKey: "scale")
          
          layer.addSublayer(textLayer)
        }
    
    func filter_ashwaq () {
        
    }
    
    func filter_maram () {
        
    }
    
    func filter_lama () {
        
    }
}
