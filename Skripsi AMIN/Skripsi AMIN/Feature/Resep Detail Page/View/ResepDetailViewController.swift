//
//  ResepDetailViewController.swift
//  Skripsi AMIN
//
//  Created by Ivan Valentino Sigit on 18/01/22.
//

import UIKit

class ResepDetailViewController: UIViewController {

    @IBOutlet weak var resepImage: UIImageView!
    @IBOutlet weak var titleResep: UILabel!
    @IBOutlet weak var durasi: UILabel!
    @IBOutlet weak var porsi: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Hold API Detail Resep Data
    var detailData: DetailContent?
    
    var resepKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(addTapped))
        self.tabBarController?.tabBar.isHidden = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupTableView()
        fetchData()
    }
    
    @objc func addTapped(sender: AnyObject){
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    func loadDetail(){
        guard let detail = detailData else{
            return
        }
        
        guard let image = detail.thumb else{
            return
        }
        
        resepImage.image = UIImage(data: Constant.shared.getImage(urlKey: image))
        titleResep.text = detail.title
        durasi.text = detail.times
        porsi.text = detail.servings
        level.text = detail.dificulty
        
        
    }

    fileprivate func setupTableView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 423).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        tableView.register(DropDown.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    let data = [
        DropData(title: "Bahan", desc: "Bawang Putih 10 g\nMerica 1 sdt\n"),
        DropData(title: "Langkah", desc: "1. Nyalakan Api Kecil\n2. Rebus Air")
    ]
    
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    func fetchData(){
        API.shared.fetchDetailAPI(urlKey: resepKey) { data in
            self.detailData = data
//            guard let detail = self.detailData else{
//                return
//            }
//            print(detail)
//            print(self.resepKey)
            DispatchQueue.main.async {
                self.loadDetail()
                self.tableView.reloadData()
            }
        }
    }
}

struct DropData{
    var title: String
    var desc: String
}

extension ResepDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DropDown
        cell.data = data[indexPath.row]
        cell.selectionStyle = .none
        cell.animate()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath { return 200 }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex], with: .none)
        tableView.endUpdates()
    }
}

