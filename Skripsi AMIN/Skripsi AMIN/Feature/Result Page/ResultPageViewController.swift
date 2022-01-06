//
//  ResultPageViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 04/01/22.
//

import UIKit



class ResultPageViewController: UIViewController {
    

    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var rekomenLabel: UILabel!
    
    @IBOutlet  var captureResult: UIImageView!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureResult.image = ImageModel.shared.image
        navigationController?.navigationBar.tintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.backgroundColor = UIColor(named: "Secondary")
    }

}