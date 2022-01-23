//
//  TabBarController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let appearance = UINavigationBarAppearance()
    
    // Mark: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notif = NotifikasiViewController()
        notif.userNotificationCenter.delegate = notif
        notif.requestNotificationAuthorization()
        notif.scheduleNotification(body: "Wah ada menu baru nih!", titles: "Mari masak bersama")

        setUp()
        setupVC()
        setupIdentifikasiBtn()
        
    }
    
    func setUp() {
        tabBar.barTintColor = UIColor(named: "SecondaryColor")
        tabBar.tintColor = UIColor(named: "PrimaryColor")
        tabBar.unselectedItemTintColor = .white
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor(named: "SecondaryColor")
    }
    
    // Mark: Create Navigation Controller for Main Page with Tab Bar
    fileprivate func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        
         // MARK: Navbar custom color
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "SecondaryColor")
        navigationController.navigationBar.standardAppearance = appearance;
        navigationController.navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "SecondaryColor")!, NSAttributedString.Key.font: UIFont(name: "Poppins-SemiBold", size: 17)!]
    
         // MARK: custom left right navbar
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 17)!], for: .normal)
        navigationController.navigationBar.tintColor = UIColor(named: "TextColor")
         // MARK: blm berfungsi
        navigationController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backBtn))
        navigationController.navigationItem.backButtonTitle = "Kembali"
        navigationController.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "TextColor")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 10)!], for: .normal)
        
        return navigationController
    }
    
    @objc func backBtn() {
        navigationController?.popToRootViewController(animated: true)
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
