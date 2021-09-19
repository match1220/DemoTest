
//
//  SpinningIndicator.swift
//  origami
//
//  Created by Toshihiro Yamazaki on 2019/04/26.
//  Copyright © 2018 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

public class SpinningIndicator: UIView {
    
    public var size = CGSize(width: 24, height: 24)
    public var isAnimating = false
    public var strokeEnd: Double = 0.8
    
    private var circleLayers = [CAShapeLayer]()
    private let rotationAnimKey = "rotation"
    private let strokeEndAnimKey = "strokeEnd"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.size = frame.size
    }
    
    public func addCircle(lineColor: UIColor, lineWidth: CGFloat, radius: CGFloat, angle: CGFloat) {
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let startAngle = -CGFloat.pi / 2 + angle
        let endAngle = startAngle + 2 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let circleLayer = CAShapeLayer()
        
        circleLayer.frame = CGRect(origin: .zero, size: size)
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = lineColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = kCALineCapRound
        circleLayer.backgroundColor = UIColor.clear.cgColor
        circleLayer.path = path.cgPath
        circleLayer.strokeEnd = 0
        layer.addSublayer(circleLayer)
        circleLayers.append(circleLayer)
    }
    
    public func beginAnimating() {
        isAnimating = true
        let min = CGFloat(0.02)
        let max = CGFloat(strokeEnd)
        DispatchQueue.main.async {
            if self.layer.animation(forKey: self.rotationAnimKey) == nil {
                self.layer.add(self.rotationAnimation, forKey: self.rotationAnimKey)
            }
            self.circleLayers.forEach { $0.add(
                self.keyFrameRotationAnimation(
                    duration: 2,
                    times: [0, 0.3, 0.7, 1],
                    values: [0, 0.15, 0.85, 1],
                    timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    repeatCount: Float.infinity),
                forKey: self.rotationAnimKey)
            }
            self.circleLayers.forEach { $0.add(
                self.keyFrameStrokeEndAnimation(
                    duration: 2,
                    times: [0, 0.2, 0.3, 0.7, 1],
                    values: [min, max, max, min, min],
                    timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                    repeatCount: Float.infinity),
                forKey: self.strokeEndAnimKey)
            }
        }
    }
    
    public func endAnimating() {
        isAnimating = false
        DispatchQueue.main.async {
            self.layer.removeAllAnimations()
            self.circleLayers.forEach { $0.removeAllAnimations() }
            self.circleLayers.forEach { $0.strokeEnd = 0 }
        }
    }
}

extension SpinningIndicator {
    
    public func beginAnimatingFromShrink() {
        isAnimating = true
        DispatchQueue.main.async {
            if self.layer.animation(forKey: self.rotationAnimKey) == nil {
                self.layer.add(self.rotationAnimation, forKey: self.rotationAnimKey)
            }
            self.shrink()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                self.circleLayers.forEach { $0.removeAllAnimations() }
                self.beginAnimating()
            })
        }
    }
    
    public func shrink() {
        let min = CGFloat(0.02)
        let max = CGFloat(strokeEnd)
        circleLayers.forEach { $0.strokeEnd = min }
        circleLayers.forEach { $0.add(
            self.keyFrameRotationAnimation(
                duration: 0.4,
                times: [0, 1],
                values: [0, 0.66],
                timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)),
            forKey: self.rotationAnimKey)
        }
        circleLayers.forEach { $0.add(
            self.keyFrameStrokeEndAnimation(
                duration: 0.4,
                times: [0, 1],
                values: [max, min],
                timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)),
            forKey: self.strokeEndAnimKey)
        }
    }
}

/**
 * Animation Utility
 */
extension SpinningIndicator {
    
    private var rotationAnimation: CABasicAnimation {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = CGFloat.pi * 1
        anim.duration = 2
        anim.repeatCount = MAXFLOAT
        anim.isCumulative = true
        return anim
    }
    
    private func keyFrameRotationAnimation(duration: Double, times: [NSNumber], values: [CGFloat], timingFunction: CAMediaTimingFunction, repeatCount: Float = 0) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "transform.rotation")
        anim.isCumulative = true
        anim.duration = duration
        anim.keyTimes = times
        anim.values = values.compactMap({ $0 * 3 * CGFloat.pi })
        anim.timingFunction = timingFunction
        anim.repeatCount = repeatCount
        return anim
    }
    
    private func keyFrameStrokeEndAnimation(duration: Double, times: [NSNumber], values: [CGFloat], timingFunction: CAMediaTimingFunction, repeatCount: Float = 0) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "strokeEnd")
        anim.duration = duration
        anim.keyTimes = times
        anim.values = values
        anim.timingFunction = timingFunction
        anim.repeatCount = repeatCount
        return anim
    }
}
