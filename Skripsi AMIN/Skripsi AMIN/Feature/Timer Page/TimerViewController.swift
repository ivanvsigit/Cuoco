//
//  TimerViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 11/01/22.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBAction func startButton(_ sender: UIButton) {
        self.progressView.start(beginingValue: 10, interval: 1.0)
    }
    @IBOutlet weak var progressView: CircularProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TimerHandleDelegate set
       // self.progressView.delegate = self
    }

}

extension TimerViewController: TimerHandleDelegate {
    func counterUpdateTimeValue(with sender: CircularProgressView, newValue: Int) {
        print("CURRENT VALUE IS: \(newValue)")
    }
    
    func didStartTimer(sender: CircularProgressView) {
        print("PROGRESS ANIMATION STARTED ")
    }
    
    func didEndTimer(sender: CircularProgressView) {
        print("PROGRESS ANIMATION FINISHD ")
    }
}
