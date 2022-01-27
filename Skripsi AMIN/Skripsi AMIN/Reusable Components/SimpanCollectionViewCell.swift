//
//  SimpanCollectionViewCell.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 13/01/22.
//

import UIKit

 // MARK: Passing func
protocol simpanColDelegate {
    func triggerReloadCollection()
}

class SimpanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var simpanView: UIView!
    @IBOutlet weak var simpanImage: UIImageView!
    @IBOutlet weak var simpanLabelBG: UIView!
    @IBOutlet weak var simpanLabel: UILabel!
    @IBOutlet weak var simpanBtn: UIButton!
    
    weak var vc: UIViewController?
    var delegate: simpanColDelegate?
    
    @IBAction func simpanBtn(_ sender: Any) {
        for data in DataManipulation.shared.model {
            if data.key == tempModelSCol?.key { //MARK: Hapus Resep
                let alert = UIAlertController(title: "Hapus Resep", message: "Anda yakin ingin menghapus resep ini?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ya", style: .destructive, handler: { _ in
                    DataManipulation.shared.updateItem(key: data.key, value: false)
                    self.delegate?.triggerReloadCollection()
                }))
                alert.addAction(UIAlertAction(title: "Tidak", style: .cancel, handler: nil))
                vc?.present(alert, animated: true, completion: nil)
                print("Resep Dihapus!")
            }
        }
    }
    
    // MARK: Property Observer
    var tempModelSCol: CoreDetail? {
        didSet {
            setupContent()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        simpanLabelBG.backgroundColor = UIColor(named: "SecondaryColor")
        simpanLabel.font = UIFont(name: "Poppins-Medium", size: 17)
        simpanLabel.textColor = UIColor(named: "TextColor")
    }
    
    func setupContent() {
        guard let data = tempModelSCol else {
            return
        }
        
        simpanImage.image = UIImage(data: Constant.shared.getImage(urlKey: data.image!))
        let newTitle = data.label!.components(separatedBy: ",")
        print(newTitle)
        simpanLabel.text = newTitle[0]
    }


}
