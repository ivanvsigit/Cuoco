//
//  ProgressBarTimerViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 13/01/22.
//

import UIKit

class ProgressBarTimerViewController: UIViewController {

    @IBAction func batalButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
         }
    }
    @IBAction func jedaButton(_ sender: UIButton) {
        
    }
    
        var isPaused = true
        private var playTimer: NSObject?
        let timeLeftShapeLayer = CAShapeLayer()
        let bgShapeLayer = CAShapeLayer()
        var timeLeft: TimeInterval = 20
//        var startTime: Date?
        var endTime: Date?
        var timeLabel =  UILabel()
        var timer: Timer? = Timer()
        // here you create your basic animation object to animate the strokeEnd
        let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
//    func isPaused() -> Bool{
//        guard let timer = timer else { return false }
//        return !timer.isValid
//    }
    
    func pause() {
//            timeLeft = Date.timeIntervalSinceReferenceDate - (startTime ?? 0.0)
//            timer?.invalidate()
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
            drawBgShape()
            drawTimeLeftShape()
            addTimeLabel()
            
            // here you define the fromValue, toValue and duration of your animation
            strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = timeLeft
            
            // add the animation to your timeLeftShapeLayer
            timeLeftShapeLayer.add(strokeIt, forKey: nil)
            
            // define the future end time by adding the timeLeft to now Date()
//            startTime = Date.timeIntervalSinceReferenceDate
            endTime = Date().addingTimeInterval(timeLeft)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
        
        func drawBgShape() {
            bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                174, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
            bgShapeLayer.strokeColor = UIColor(named: "SecondaryColor")?.cgColor
            bgShapeLayer.fillColor = UIColor.clear.cgColor
            bgShapeLayer.lineWidth = 25
            view.layer.addSublayer(bgShapeLayer)
        }
        func drawTimeLeftShape() {
            timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY), radius:
                174, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
            timeLeftShapeLayer.strokeColor = UIColor(named: "PrimaryColor")?.cgColor
            timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
            timeLeftShapeLayer.lineCap = .round
            timeLeftShapeLayer.lineWidth = 25
            view.layer.addSublayer(timeLeftShapeLayer)
        }
        
        func addTimeLabel() {
            timeLabel = UILabel(frame: CGRect(x: view.frame.midX-100 ,y: view.frame.midY-25, width: 200, height: 50))
            timeLabel.textAlignment = .center
            timeLabel.text = timeLeft.time
            timeLabel.textColor = UIColor(named: "TextColor")
            timeLabel.font = UIFont(name: "Poppins-Bold", size: 42)
            view.addSubview(timeLabel)
        }
        
        @objc func updateTime() {
            if timeLeft > 0 {
                timeLeft = endTime?.timeIntervalSinceNow ?? 0
                timeLabel.text = timeLeft.time
            } else {
                timeLabel.text = "00:00:00"
                timer?.invalidate()
            }
        }

    }

    extension TimeInterval {
        var time: String {
            return String(format:"%02d:%02d:%02d", Int((self/3600).truncatingRemainder(dividingBy: 3600)),  Int((self/60).truncatingRemainder(dividingBy: 60)), Int(truncatingRemainder(dividingBy: 60)))
        }
    }

    extension Int {
        var degreesToRadians : CGFloat {
            return CGFloat(self) * .pi / 180
        }
    }
