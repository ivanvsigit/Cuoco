//
//  LaunchViewController.swift
//  Skripsi AMIN
//
//  Created by Olga Husada on 20/01/22.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var appName: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        image.animationImages = (0...2).map ({
            value in return UIImage(named: "animated-3-\(value)") ?? UIImage()
        })
        image.animationRepeatCount = -1
        image.animationDuration = 1
        image.startAnimating()
        
        appName.image = UIImage(named: "CUOCO")
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
