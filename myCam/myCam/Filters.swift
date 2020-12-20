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
    var imageLayer : CALayer!
    var imageLayer1:CALayer!
    var imageLayer2: CALayer!
    var textLayer2: CATextLayer!
    var emitter : CAEmitterLayer!
    func filter_hanan (text: String, to layer: CALayer, videoSize: CGSize) {
        
        
        
    
          let attributedText = NSAttributedString(
            string: text,
            attributes: [
              .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
                .foregroundColor: UIColor.purple ,
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
    
     func addConfetti(to layer: CALayer) {
      let images: [UIImage] = (0...5).map { UIImage(named: "confetti\($0)")! }
      let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemPink, .systemOrange, .systemPurple, .systemYellow]
      let cells: [CAEmitterCell] = (0...16).map { _ in
        let cell = CAEmitterCell()
        cell.contents = images.randomElement()?.cgImage
        cell.birthRate = 3
        cell.lifetime = 12
        cell.lifetimeRange = 0
        cell.velocity = CGFloat.random(in: 100...200)
        cell.velocityRange = 0
        cell.emissionLongitude = 0
        cell.emissionRange = 0.8
        cell.spin = 4
        cell.color = colors.randomElement()?.cgColor
        cell.scale = CGFloat.random(in: 0.2...0.8)
        return cell
      }
      
      self.emitter = CAEmitterLayer()
      emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
      emitter.emitterShape = .line
      emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
      emitter.emitterCells = cells
      
      layer.addSublayer(emitter)
    }
        
    
    
    
    func filter_ashwaq (text: String, to layer: CALayer, videoSize: CGSize) {
        
        
        
        let image1 = UIImage(named: "ashwaq")!
        self.imageLayer1 = CALayer()

        let aspect1: CGFloat = image1.size.width / image1.size.height
              let width = videoSize.width
              let height = width / aspect1
        imageLayer1.frame = CGRect(
                x: -171 ,
                y: -187,
                width: 714,
                height: 556)

              imageLayer1.contents = image1.cgImage
              layer.addSublayer(imageLayer1)
        //
        
        let image2 = UIImage(named: "trees")!
        self.imageLayer2 = CALayer()
              
        let aspect2: CGFloat = image2.size.width / image2.size.height
              let width2 = videoSize.width
              let height2 = width2 / aspect2
        
              imageLayer2.frame = CGRect(
                x: -85 ,
                y: 550 ,
                width: width2,
                height: height2)
              imageLayer2.contents = image2.cgImage
              layer.addSublayer(imageLayer2)
        //
        
        let attributedText = NSAttributedString(
          string: text,
          attributes: [
            .font: UIFont(name: "zapfino", size: 25) as Any,
            .foregroundColor: UIColor.red ,
            .strokeColor: UIColor.white,
            .strokeWidth: -2])
        
        self.textLayer2 = CATextLayer()
        textLayer2.string = attributedText
        textLayer2.shouldRasterize = true
        textLayer2.rasterizationScale = UIScreen.main.scale
        textLayer2.backgroundColor = UIColor.clear.cgColor
        textLayer2.alignmentMode = .center
        
        textLayer2.frame = CGRect(
          x: 10,
          y: 200 ,
          width: videoSize.width,
          height: 150)
        textLayer2.displayIfNeeded()
        layer.addSublayer(textLayer2)
        
            
        
        
        
    }
    
    func filter_maram () {
        
    }
    
    func filter_lama (to layer: CALayer, videoSize: CGSize) {
        
    
        
        let image = UIImage(named: "fireworks")!
        self.imageLayer = CALayer()
              
        let aspect: CGFloat = image.size.width / image.size.height
              let width = videoSize.width
              let height = width / aspect
        
              imageLayer.frame = CGRect(
                x: 150,
                y: height * 1.23,
                width: 120,
                height: 120)
              
        
    
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
        
        }
    
    }

