//
//  ResepViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class ResepViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "HighlightTableViewCell", bundle: nil), forCellReuseIdentifier: "highlightCell")

        
    }


}

extension ResepViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highlightCell") as! HighlightTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 234
    }
   
    
    
}
