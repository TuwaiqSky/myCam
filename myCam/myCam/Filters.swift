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
    var emitter: CAEmitterLayer!
    var imageLayer: CALayer!
    
    func addTextFilter(text: String, to layer: CALayer, videoSize: CGSize) {
        
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
        
        emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
        emitter.emitterCells = cells
        
        layer.addSublayer(emitter)
    }
    
    func addFireworksImage(to layer: CALayer, videoSize: CGSize) {
        let image = UIImage(named: "fireworks")!
        
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
