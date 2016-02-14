//
//  RangeSlider.swift
//  RangeSliderExample
//
//  Created by Alexander Naumov on 13.02.16.
//  Copyright © 2016 Alexander Naumov. All rights reserved.
//

import UIKit


@IBDesignable class RangeSlider: UIControl {
    
    @IBInspectable var minimum: CGFloat = 0
    @IBInspectable var maximum: CGFloat = 1
    @IBInspectable var minRange: CGFloat = 0.1
    
    @IBInspectable var selectedMin: CGFloat = 0
    @IBInspectable var selectedMax: CGFloat = 1
    
    @IBOutlet weak var track: UIImageView! {
        didSet {
            track.image = track.image?.imageWithRenderingMode(.AlwaysTemplate)
        }
    }
    
    @IBOutlet weak var minThumbLayout: NSLayoutConstraint!
    @IBOutlet weak var maxThumbLayout: NSLayoutConstraint!
    @IBOutlet weak var minTrackLayout: NSLayoutConstraint!
    @IBOutlet weak var maxTrackLayout: NSLayoutConstraint!
    
    @IBOutlet weak var minThumb: UIImageView!
    @IBOutlet weak var maxThumb: UIImageView!
    
    private var padding: CGFloat = 14
    private var distanceFromCenter: CGFloat!
    private var maxThumbOn = false
    private var minThumbOn = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        let view = UINib(nibName: "RangeSlider", bundle: NSBundle(forClass: self.dynamicType)).instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let minX = xForValue(selectedMin)
        let maxX = frame.width - xForValue(selectedMax)
        
        minThumbLayout.constant = minX - minThumb.frame.width / 2
        maxThumbLayout.constant = maxX - maxThumb.frame.width / 2
        
        minTrackLayout.constant = minX
        maxTrackLayout.constant = maxX
    }
    
    private func xForValue(value: CGFloat) -> CGFloat {
        return (((frame.width - padding * 2) * (value - minimum)) / (maximum - minimum)) + padding
    }
    
    private func valueForX(x: CGFloat) -> CGFloat {
        return minimum + (x - padding) / (frame.width - padding * 2) * (maximum - minimum)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let touchPoint = touch.locationInView(self)
        
        if CGRectContainsPoint(minThumb.frame, touchPoint) {
            minThumbOn = true;
            distanceFromCenter = touchPoint.x - minThumb.center.x
        } else if CGRectContainsPoint(maxThumb.frame, touchPoint) {
            maxThumbOn = true;
            distanceFromCenter = touchPoint.x - maxThumb.center.x
        }
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        if !minThumbOn && !maxThumbOn {
            return true
        }
        
        let touchPoint = touch.locationInView(self)
        
        if minThumbOn {
            selectedMin = valueForX(max(xForValue(minimum), min(touchPoint.x - distanceFromCenter, xForValue(selectedMax - minRange))))
        }
        
        if maxThumbOn {
            selectedMax = valueForX(min(xForValue(maximum), max(touchPoint.x - distanceFromCenter, xForValue(selectedMin + minRange))))
        }
        
        setNeedsLayout()
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        minThumbOn = false
        maxThumbOn = false
    }
}
