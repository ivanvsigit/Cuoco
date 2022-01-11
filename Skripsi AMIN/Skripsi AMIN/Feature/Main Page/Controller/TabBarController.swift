//
//  TabBarController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // Mark: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        UITabBar.appearance().tintColor = UIColor(named: "PrimaryColor")
        
        setupVC()
        setupIdentifikasiBtn()
        
    }
    
    // Mark: Create Navigation Controller for Main Page with Tab Bar
    fileprivate func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        // rootViewController.navigationItem.title = title
        
        return navigationController
    }
    
    //Mark: Setup ViewController for Page
    func setupVC() {
        viewControllers = [
            //Mark: - UIImage are not supported below iOS 15, the original was menucard and clock
            createNavigationController(for: ResepViewController(), title: String("Resep"), image: UIImage(systemName: "book.fill")!),
//            createNavigationController(for: IdentifikasiViewController(), title: String("Identifikasi"), image: UIImage(systemName: "camera.fill")!),
            createNavigationController(for: SimpanViewController(), title: String("Simpan"), image: UIImage(systemName: "bookmark.fill")!)]
    
    }

     // MARK: Setup Custom Tab Bar Button
    func setupIdentifikasiBtn() {
        let identifikasiBtn = UIButton(frame: CGRect(x: (self.view.bounds.width/2) - 30, y: -20, width: 60, height: 60))
        identifikasiBtn.backgroundColor = UIColor(named: "PrimaryColor")
        identifikasiBtn.setImage(UIImage(named: "CameraBtn"), for: .normal)
        
        identifikasiBtn.tintColor = .white
        identifikasiBtn.layer.cornerRadius = 30
        
        self.tabBar.addSubview(identifikasiBtn)
        identifikasiBtn.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
    }
    
    @objc func openCamera() {
        let vc = IdentifikasiViewController()
        let navigationWrapper = UINavigationController(rootViewController: vc)
        navigationWrapper.modalPresentationStyle = .fullScreen
        self.present(navigationWrapper, animated: true, completion: nil)
    }

}
