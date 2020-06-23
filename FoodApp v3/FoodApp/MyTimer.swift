//
//  MyTimer.swift
//  FoodApp
//
//  Created by Eljah Andrushenko on 2/4/20.
//  Copyright © 2020 Elijah Andrushenko. All rights reserved.
//

import Foundation

protocol MyTimerDelegate {
    func timeChanged (time: Int)
    func timesUp ()
}

class MyTimer {
    var delegate: MyTimerDelegate?
    var initialTime: Int = 5
    var currentTime: Int = 5
    
    var timer: Timer?
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: handleTick)
    }
    
    func handleTick(timer: Timer){
        if currentTime > 0 {
            currentTime -= 1
            delegate?.timeChanged(time: currentTime)
            if currentTime == 0 {
                delegate?.timesUp()
            }
        }
    }
    
    func setInitialTime(_ initTime: Int) {
        initialTime = initTime
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func reset() {
        if currentTime != initialTime {
            currentTime = initialTime
            delegate?.timeChanged(time: currentTime)
        }
    }
    
}
