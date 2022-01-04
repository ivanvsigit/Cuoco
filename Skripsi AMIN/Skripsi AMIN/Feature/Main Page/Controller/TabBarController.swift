//
//  TabBarController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 30/12/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    // Mark: App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVC()
        
    }
    
    // Mark: - Create Navigation Controller for Main Page with Tab Bar
    fileprivate func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        // rootViewController.navigationItem.title = title
        
        return navigationController
    }
    
    //Mark: -Setup ViewController for Main Page
    func setupVC() {
        viewControllers = [
            //Mark: - UIImage are not supported below iOS 15, the original was menucard and clock
            createNavigationController(for: ResepViewController(), title: String("Resep"), image: UIImage(systemName: "book.fill")!),
            createNavigationController(for: IdentifikasiViewController(), title: String("Identifikasi"), image: UIImage(systemName: "camera.fill")!),
            createNavigationController(for: SimpanViewController(), title: String("Simpan"), image: UIImage(systemName: "bookmark.fill")!)]
    
    }
    

}
