//
//  ProgressBarView.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 13/01/22.
//

import UIKit

protocol TimerDelegate{
    func counterUpdateTimeValue(with sender: ProgressBarView, newValue: Int)
    func didStartTimer(sender: ProgressBarView)
    func didEndTimer(sender: ProgressBarView)
}

@IBDesignable class ProgressBarView: UIView {
    
    //Delegate
    var delegate: TimerDelegate?
    
    //WidthCicularBar
    @IBInspectable public var barLineWidth: CGFloat = 25
    //BGColor
    @IBInspectable public var barBackLineColor = UIColor(named: "SecondaryColor")?.cgColor
    //FrontColor
    @IBInspectable public var barFrontLineColor = UIColor(named: "PrimaryColor")?.cgColor
    //ToHideTimerLabel
    @IBInspectable public var isTextLabelHidden: Bool = false
    //ToShowWhenTimerFinished
    @IBInspectable public var timerFinishingText: String?
    
    //Vars
    public var isMinutesAndSecondsShow = true
    public var isMovingClockWise = false
    
    private var timer: Timer?
    private var beginingValue: Int = 1
    private var totalTime: TimeInterval = 1
    private var elapsedTime: TimeInterval = 0
    private var remainingTime: TimeInterval = 1
    private var interval: TimeInterval = 1 // Interval which is set by a user
    private let fireInterval: TimeInterval = 0.01 // ~60 FPS
    
    //TimerLabel
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "PrimaryColor")
        label.numberOfLines  = 3
        self.addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.frame = self.bounds
        label.font = UIFont(name: "Poppins-Bold", size: 48)
        return label
    }()
    
    private var currentCounterValue: Int = 0 {
        didSet {
            if !isTextLabelHidden {
                if let text = timerFinishingText, currentCounterValue == 0 {
                    counterLabel.text = text
                } else {
                    if isMinutesAndSecondsShow {
                        counterLabel.text = getMinutesAndSeconds(remainingSeconds: currentCounterValue)
                    } else {
                        counterLabel.text = "\(currentCounterValue)"
                    }
                }
            }
            delegate?.counterUpdateTimeValue(with: self, newValue: currentCounterValue)
        }
    }
    
    override public init(frame: CGRect) {
        if frame.width != frame.height {
            fatalError("Please use a rectangle frame for SRCountdownTimer")
        }
        super.init(frame: frame)
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        let radius = (rect.width - barLineWidth) / 2
        
        var currentAngle : CGFloat!
        
        if isMovingClockWise {
            currentAngle = CGFloat((.pi * 2 * elapsedTime) / totalTime)
        } else {
            currentAngle = CGFloat(-(.pi * 2 * elapsedTime) / totalTime)
        }
    
        context?.setLineWidth(barLineWidth)

        // Main line
        context?.beginPath()
        context?.addArc(
            center: CGPoint(x: rect.midX, y:rect.midY),
            radius: radius,
            startAngle: currentAngle - .pi / 2,
            endAngle: .pi * 2 - .pi / 2,
            clockwise: isMovingClockWise)
        context?.setStrokeColor(barBackLineColor!)
        context?.strokePath()
        context?.setLineCap(.round)

        // Trail line
        context?.beginPath()
        context?.addArc(
            center: CGPoint(x: rect.midX, y:rect.midY),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: currentAngle - .pi / 2,
            clockwise: isMovingClockWise)
        context?.setStrokeColor(barFrontLineColor!)
        context?.setLineCap(.round)
        context?.strokePath()
    }

    // MARK: Starts the timer and the animation.
    public func start(beginingValue: Int, interval: TimeInterval = 1) {
        //Start timer
        self.delegate?.didStartTimer(sender: self)
        //Set Inintial value and time inteerval
        self.beginingValue = beginingValue
        self.interval = interval

        totalTime = TimeInterval(beginingValue) * interval
        elapsedTime = 0
        //update value here.
        currentCounterValue = beginingValue
        //invalidate Timer
        timer?.invalidate()
        //Re-initialize TImer
        timer = Timer(timeInterval: fireInterval, target: self, selector: #selector(ProgressBarView.timerFired(_:)), userInfo: nil, repeats: true)
        //add timer in Runloop
        RunLoop.main.add(timer!, forMode: .common)

    }


    //MARK:- Reset the timer
    public func reset() {
        self.currentCounterValue = 0
        timer?.invalidate()
        self.elapsedTime = 0
        setNeedsDisplay()
    }
    
    //MARK:- End the timer
    public func end() {
        //1. Timer
        self.currentCounterValue = 0
        timer?.invalidate()
        //2. Deelegate
        delegate?.didEndTimer(sender: self)
    }
    
    public func pause(){
        if timer != nil{
            timer?.invalidate()
            remainingTime = totalTime - elapsedTime
            timer = nil
        }else{
            timer = Timer(timeInterval: fireInterval, target: self, selector: #selector(ProgressBarView.timerFired(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    //MARK:- Calculate value in minutes and seconds and return it as String
    private func getMinutesAndSeconds(remainingSeconds: Int) -> (String) {
        let hours = remainingSeconds / 3600
        let minutes = remainingSeconds / 60 % 60
        let seconds = remainingSeconds % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

    // MARK: Private methods
    @objc private func timerFired(_ timer: Timer) {
        elapsedTime += fireInterval
        //Check if elapsedTime is less than totalTime
        if elapsedTime <= totalTime {
            setNeedsDisplay()
            let computedCounterValue = beginingValue - Int(elapsedTime / interval)
            if computedCounterValue != currentCounterValue {
                currentCounterValue = computedCounterValue
            }
        } else {
            end()
        }
    }
}
