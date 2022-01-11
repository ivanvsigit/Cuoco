//
//  ResultPageViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 04/01/22.
//

import UIKit



class ResultPageViewController: UIViewController {
    
    @IBAction func backButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
         }
    }
    
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var rekomenLabel: UILabel!
    
    @IBOutlet  var captureResult: UIImageView!
     
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Nav Bar
        navigationController?.title = "Hasil"
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        //navigationController?.navigationBar.tintColor = UIColor(named: "Primary")
        //navigationController?.navigationBar.backgroundColor = UIColor(named: "Secondary")

        //PassingData
        captureResult.image = ImageModel.shared.image
        
    }

}
