//
//  ResepDetailViewController.swift
//  Skripsi AMIN
//
//  Created by Ivan Valentino Sigit on 18/01/22.
//

import UIKit
import CoreData

struct DropData{
    var opened: Bool
    var title: String
    var desc: [String]
}

class ResepDetailViewController: UIViewController {

    @IBOutlet weak var resepImage: UIImageView!
    @IBOutlet weak var titleResep: UILabel!
    @IBOutlet weak var durasi: UILabel!
    @IBOutlet weak var porsi: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Hold API Detail Resep Data
    var detailData: DetailContent?
    var tableViewData: [DropData] = []
    
    //MARK: Loading Animation
    let imgLoad: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.animationImages = (0...5).map ({
            value in return UIImage(named: "animated-1-\(value)") ?? UIImage()
        })
        image.animationRepeatCount = -1
        image.animationDuration = 1
        image.startAnimating()
        
        return image
    }()
    
    
    var resepKey: String = ""
    
//    let timer: TimerViewController
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(savedTapped))
        self.tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        
        durasi.baselineAdjustment = .alignCenters
        porsi.baselineAdjustment = .alignCenters
        level.baselineAdjustment = .alignCenters
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        fetchData()
        DataManipulation.shared.getItem()
    }
    
    @objc func addTapped(sender: AnyObject){
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func savedTapped(sender: AnyObject){
        for data in DataManipulation.shared.model{
            if data.key == resepKey{
                if data.saved == false {
                    DataManipulation.shared.updateItem(key: resepKey, value: true)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hapus", style: .plain, target: self, action: #selector(savedTapped))
                    let alert = UIAlertController(title: "Simpan Resep", message: "Resep telah tersimpan", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if data.saved == true{
//                    self.dismiss(animated: false, completion: nil)
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(savedTapped))
                    let alert = UIAlertController(title: "Hapus Resep", message: "Anda yakin ingin menghapus resep ini?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ya", style: .destructive, handler: { _ in
                        DataManipulation.shared.updateItem(key: self.resepKey, value: false)
                    }))
                    alert.addAction(UIAlertAction(title: "Tidak", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadDetail(){
        guard let detail = detailData else{
            return
        }
        
        guard let image = detail.thumb else{
            return
        }
        
        resepImage.image = UIImage(data: Constant.shared.getImage(urlKey: image))
        titleResep.numberOfLines = 5
        titleResep.text = detail.title
        durasi.text = detail.times
        porsi.text = detail.servings
        level.text = detail.dificulty
        tableViewData = [
            DropData(opened: false, title: "Bahan", desc: detail.ingredient),
            DropData(opened: false, title: "Langkah", desc: detail.step)
        ]
    }

    func setupTableView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 423).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        tableView.register(UINib(nibName: "\(DetailTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "dropDown")
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    func fetchData(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        DispatchQueue.main.async {
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.view.addSubview(blurEffectView)
            self.view.addSubview(self.imgLoad)
            self.imgLoad.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.imgLoad.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.imgLoad.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.imgLoad.widthAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        API.shared.fetchDetailAPI(urlKey: resepKey) { data in
            self.detailData = data
            guard let image = data.thumb else{
                return
            }
            
            DataManipulation.shared.createItem(title: data.title, thumb: image, key: self.resepKey, saved: false)
//            guard let detail = self.detailData else{
//                return
//            }
//            print(detail)
//            print(self.resepKey)
            DispatchQueue.main.async {
                self.loadDetail()
                self.tableView.reloadData()
                self.imgLoad.removeFromSuperview()
                blurEffectView.removeFromSuperview()
            }
        }
    }
    
}

extension ResepDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].desc.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        guard let detail = detailData else{
            return tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
        }
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 20)
            cell.dropBtn.isHidden = false
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
            cell.textLabel?.text = tableViewData[indexPath.section].desc[dataIndex]
            cell.textLabel?.font = UIFont(name: "Poppins-Regular", size: 14)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textAlignment = .justified
            cell.dropBtn.isHidden = true
            
            let timerBtn = UIButton(frame: CGRect(x: 230, y: 144, width: 100, height: 40))
            timerBtn.backgroundColor = UIColor(named: "PrimaryColor")
            timerBtn.setTitle("Timer", for: .normal)
            timerBtn.tintColor = .white
            timerBtn.layer.cornerRadius = 10
            
            for i in 0..<detail.step.count {
                if detail.step[i].contains("menit") {
                    print("kasih timer")
                    view.addSubview(timerBtn)
                } else {
                    print("gaperlu timer")
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dropDown") as! DetailTableViewCell
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                cell.dropBtn.image = UIImage(named: "chevron.up")
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
                cell.dropBtn.image = UIImage(named: "chevron.up")
            }
        }
        
//        selectedIndex = indexPath
//
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [selectedIndex], with: .none)
//        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 200
        }
        return UITableView.automaticDimension
    }
    
}

