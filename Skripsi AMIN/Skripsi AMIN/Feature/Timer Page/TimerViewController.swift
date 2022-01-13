//
//  TimerViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 11/01/22.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBAction func startButton(_ sender: UIButton) {
        self.ProgressBar.start(beginingValue: 10, interval: 1.0)
    }
    
    @IBOutlet weak var ProgressBar:ProgressBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ProgressBar.delegate = self
    }

}

extension TimerViewController: TimerDelegate {
    func counterUpdateTimeValue(with sender: ProgressBarView, newValue: Int) {
        print("CURRENT VALUE IS: \(newValue)")
    }
    
    func didStartTimer(sender: ProgressBarView) {
        print("PROGRESS ANIMATION STARTED ")
    }
    
    func didEndTimer(sender: ProgressBarView) {
        print("PROGRESS ANIMATION FINISHD ")
    }
}
