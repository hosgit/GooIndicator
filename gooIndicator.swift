//
//  gooIndicator.swift
//  BazierTest
//
//  Created by Hos on 22/10/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit

enum LineCap:String
{
    case round
    case square
}
class gooIndicator:CAShapeLayer
{
    static let defualtRed    = UIColor(displayP3Red: 214 / 255,green: 79 / 255,blue: 63 / 255,alpha: 1.0).cgColor
    static let defaultlBue   = UIColor(displayP3Red: 74/255,green: 133/255,blue: 235/255,alpha: 1.0).cgColor
    static let defaultYellow = UIColor(displayP3Red: 240/255,green: 187/255,blue: 65/255,alpha: 1.0).cgColor
    static let defaultGreen  = UIColor(displayP3Red: 87/255,green: 163/255,blue: 91/255,alpha: 1.0).cgColor
    var radius = 20.0
    var arcPosition = CGPoint(x: 0, y: 0)
    var newLineCap = LineCap.square
    {
        didSet
        {
            switch  newLineCap
            {
            case .round:
                lineCap = kCALineCapRound
            case .square:
                lineCap = kCALineCapSquare
            }
        }
    }
   private var colors = [gooIndicator.defaultlBue,gooIndicator.defualtRed, gooIndicator.defaultYellow,gooIndicator.defaultGreen]
    
    init( position:CGPoint, radius:CGFloat,lineWidth:CGFloat)
    {
        super.init()
        self.lineWidth = lineWidth
        arcPosition = position
        configureMe()
    }
    
    internal required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    private func configureMe()
    {
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = UIColor.red.cgColor
        self.lineWidth = 7.0
        self.strokeStart = 0.0
        self.strokeEnd = 0.0
        self.lineCap = kCALineCapSquare
        self.path = createPath()
        self.addAnimationGroup()
        self.add( addCangeColorAnimation(), forKey: "color")
    }
    
    private func createPath()-> CGPath
    {
        let path = UIBezierPath()
        path.addArc(withCenter: arcPosition,
                    radius: 20,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi * 2),
                    clockwise: true)
        return path.cgPath
    }
    
    public func showIndicator(OnView:UIView)
    {
            configureMe()
            OnView.layer.addSublayer(self)
    }
    
    public func hideMe()
    {
        self.removeFromSuperlayer()
    }
}

extension gooIndicator
{
    func  createStartStrokeAnimation()-> CABasicAnimation
    {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.toValue = 1.0
        animation.duration = 1.5
        animation.fillMode = kCAFillModeBackwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.isRemovedOnCompletion = true
        return animation
    }
    
    func  createEndStrokeAnimation()-> CABasicAnimation
    {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.0
        animation.duration = 0.4
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return animation
    }
    
    func addAnimationGroup()
    {
        let animationGroup = CAAnimationGroup()
        let endStrokeAnimation = createEndStrokeAnimation()
        let startStrokeAnimation = createStartStrokeAnimation()
        animationGroup.animations = [startStrokeAnimation,endStrokeAnimation]
        animationGroup.duration = 1.5
        animationGroup.repeatCount = HUGE
        self.add(animationGroup, forKey: "google")
    }
    
    func addCangeColorAnimation()->CAAnimation
    {
        let colorAnimation =  CAKeyframeAnimation()
        colorAnimation.keyPath = "strokeColor"
        colorAnimation.values = colors
        colorAnimation.keyTimes = [0,0.25,0.5,1]
        colorAnimation.duration = 7.0
        
        colorAnimation.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        colorAnimation.repeatCount = HUGE
        return   colorAnimation
    }
}
