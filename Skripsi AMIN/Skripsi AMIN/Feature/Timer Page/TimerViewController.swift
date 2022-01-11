//
//  TimerViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 11/01/22.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController, CountdownTimerDelegate {
    
    //Countdown Timer Delegate
    func countdownTimerDone() {
        messageLabel.isHidden = false
        seconds.text = String(selectedSecs)
        countdownTimerDidStart = false
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        print("countdownTimerDone")
    }
    
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        hours.text = time.hours
        minutes.text = time.minutes
        seconds.text = time.seconds
    }
    

    //Button
    @IBAction func stopButton(_ sender: UIButton) {
        countdownTimer.stop()
        progressBar.stop()
        countdownTimerDidStart = false
    }
    @IBAction func startButton(_ sender: UIButton) {
        messageLabel.isHidden = true
        
//        if !countdownTimerDidStart{
//            countdownTimer.start()
//            progressBar.start()
//            countdownTimerDidStart = true
//            startBtn.setTitle("PAUSE",for: .normal)
//
//        }else{
//            countdownTimer.pause()
//            progressBar.pause()
//            countdownTimerDidStart = false
//            startBtn.setTitle("RESUME",for: .normal)
//        }
    }
    
    
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    
    //Var
    var countdownTimerDidStart = false
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Done!"
        
        return label
    }()
    
    let selectedSecs: Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownTimer.delegate = self
        countdownTimer.setTimer(hours: 0, minutes: 0, seconds: selectedSecs)

        view.addSubview(messageLabel)
        
        var constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        
        messageLabel.isHidden = true
        
    }
    

}
