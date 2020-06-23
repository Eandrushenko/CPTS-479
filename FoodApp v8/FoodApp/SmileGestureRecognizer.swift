//
//  SmileGestureRecognizer.swift
//  FoodApp
//
//  Created by Elijah Andrushenko on 3/11/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class SmileGestureRecognizer: UIGestureRecognizer {
    var initialPoint: CGPoint!
    var previousPoint: CGPoint!
    var midPoint: CGPoint!
    var mid: Bool!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        clearBoxes()
        print("Smile: Touches Began")
        let touch = touches.first
        if let point = touch?.location(in: self.view) {
            initialPoint = point
            previousPoint = point
            state = .began
            mid = true
            midPoint = point
        }
    }
    
    /*
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Smile: Touches Moved")
        let touch = touches.first
        if let point = touch?.location(in: self.view) {
            if ((point.x <= previousPoint.x) && (point.y >= previousPoint.y)) {
                previousPoint = point
                drawBox(point)
                state = .changed
            } else {
                state = .failed
            }
        }
    }
 */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        //print("Smile: Touches Moved")
        let touch = touches.first
        if let point = touch?.location(in: self.view) {
            if (point.x >= initialPoint.x) && (point.y >= initialPoint.y) && (previousPoint.x <= point.x) && (previousPoint.y <= point.y) && (mid == true) {
                state = .changed
                previousPoint = point
                drawBox(point)
                //print("X: \(point.x) Y:\(point.y)")
            } else if (mid == true) && (point.x >= initialPoint.x) && (point.y >= initialPoint.y) {
                state = .changed
                mid = false
                midPoint = point
                previousPoint = point
                drawBox(point)
                //print("midpoint = X: \(midPoint.x) Y:\(midPoint.y)")
            } else if (point.x >= midPoint.x) && (point.y <= midPoint.y) && (previousPoint.x <= point.x) && (previousPoint.y >= point.y) && (mid == false) {
                state = .changed
                previousPoint = point
                drawBox(point)
            } else {
                state = .failed
                print("Smile: Failed")
            }
            //print("Midpoint: \(String(mid))")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Smile: Touches Ended")
        let touch = touches.first
        if let point = touch?.location(in: self.view) {
            let d = distance(point, initialPoint)
            //if (point != initialPoint) {
            if d > 100.0 {
                state = .ended
            } else {
                state = .failed
                print("Smile: Failed")
            }
        }
    }
    
    func distance(_ point1: CGPoint, _ point2: CGPoint) -> Double {
        let xdiff = point1.x - point2.x
        let ydiff = point1.y - point2.y
        return Double(sqrt(xdiff*xdiff + ydiff*ydiff))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Smile: Touches Cancelled")
        state = .cancelled
    }
    
    override func reset() {
        print("Smile: Reset")
        //clearBoxes()
    }
    
    var boxViews: [UIView] = []
    
    func drawBox(_ point: CGPoint) {
        let boxRect = CGRect(x: point.x, y: point.y, width: 5.0, height: 5.0)
        let boxView = UIView(frame: boxRect)
        boxView.backgroundColor = UIColor.red
        self.view?.addSubview(boxView)
        boxViews.append(boxView)
    }
    
    func clearBoxes() {
        for boxView in boxViews {
            boxView.removeFromSuperview()
        }
    }
}
