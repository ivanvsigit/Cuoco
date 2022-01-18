//
//  TimerViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 11/01/22.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    
    var isStarted = false
    var isPaused = false
    var startValue = 3
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var ProgressBar:ProgressBarView!
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButton(_ sender: UIButton) {
        let pause = NSAttributedString(string: "Jeda", attributes: [.font: UIFont(name: "Poppins-Regular", size: 17)!])
        let resume = NSAttributedString(string: "Lanjut", attributes: [.font: UIFont(name: "Poppins-Regular", size: 17)!])
        
        if isStarted == false{
            self.ProgressBar.start(beginingValue: startValue, interval: 1.0)
            isStarted = true
            startButton.setAttributedTitle(pause, for: .normal)
        }
        else if isStarted == true && isPaused == false{
            self.ProgressBar.pause()
            isPaused = true
            startButton.setAttributedTitle(resume, for: .normal)
            //sender.setTitle("Lanjut", for: .normal)
            //sender.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20)
        }
        else if isStarted == true && isPaused == true{
            self.ProgressBar.pause()
            //sender.setTitle("Jeda", for: .normal)
            //sender.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 20)
            isPaused = false
            startButton.setAttributedTitle(pause, for: .normal)
        }
    }
    
//    var statusLabel: UILabel = {
//      let label = UILabel()
//      label.font = UIFont(name: "Poppins-Regular", size: 20)
//      return label
//    }()
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        self.ProgressBar.end()
        
        audioPlayer!.stop()
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
         }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Alarm", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let audioPlayer = audioPlayer else {
                return
            }
            audioPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ProgressBar.delegate = self
        
        //Phone'sCurrentTime
        let date = Date()
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let alarmTime = Double(hours*3600) + Double(minutes*60) + Double(startValue)
        
        timerLabel.text = alarmTime.alarm
        
        //Font
        cancelButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 17)
        startButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 17)
    }

}

extension TimeInterval{
    var alarm: String{
        return String(format: "%d: %02d", Int((self/3600).truncatingRemainder(dividingBy: 3600)), Int((self/60).truncatingRemainder(dividingBy: 60)))
    }
}

extension TimerViewController: TimerDelegate {
    func counterUpdateTimeValue(with sender: ProgressBarView, newValue: Int) {
        //print("CURRENT VALUE IS: \(newValue)")
    }
    
    func didStartTimer(sender: ProgressBarView) {
        //print("PROGRESS ANIMATION STARTED ")
    }
    
    func didEndTimer(sender: ProgressBarView) {
        playSound()
        
        //print("PROGRESS ANIMATION FINISHED ")
    }
}

