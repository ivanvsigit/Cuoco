//
//  CountdownTimer.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 11/01/22.
//

import UIKit

protocol CountdownTimerDelegate:class {
    func countdownTimerDone()
    func countdownTime(time: (hours: String, minutes: String, seconds: String))
}

class CountdownTimer {
    
    weak var delegate: CountdownTimerDelegate?
    
    fileprivate var seconds = 0.0
    fileprivate var duration = 0.0
    
    lazy var timer: Timer = {
        let timer = Timer()
        return timer
    }()
    
    //Change hours,minutes,seconds To Seconds
    public func setTimer(hours:Int, minutes:Int, seconds:Int){
        let hoursToSeconds = hours * 3600
        let minutesToSeconds = minutes * 60
        let secondsToSeconds = seconds
        
        //Sum all hours,minutes,seconds
        let seconds = secondsToSeconds + minutesToSeconds + hoursToSeconds
        self.seconds = Double(seconds)
        self.duration = Double(seconds)
        
        delegate?.countdownTime(time: timeString(time: TimeInterval(ceil(duration))))
    }
    
    //Start Timer
    public func start(){
        runTimer()
    }
    
    //Pause Timer
    public func pause(){
        timer.invalidate()
    }
    
    //Stop Timer
    public func stop(){
        timer.invalidate()
        duration = seconds
        delegate?.countdownTime(time: timeString(time: TimeInterval(ceil(duration))))
    }
    
    fileprivate func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateTimer(){
        if duration < 0.0 {
            timer.invalidate()
            timerDone()
        } else {
            duration -= 0.01
            delegate?.countdownTime(time: timeString(time: TimeInterval(ceil(duration))))
        }
    }
    
    fileprivate func timeString(time:TimeInterval) -> (hours: String, minutes: String, seconds: String){
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return (hours: String(format:"%02i", hours), minutes: String(format:"%02i", minutes), seconds: String(format:"%02i", seconds))
    }
    
    fileprivate func timerDone() {
        timer.invalidate()
        duration = seconds
        delegate?.countdownTimerDone()
    }
}
