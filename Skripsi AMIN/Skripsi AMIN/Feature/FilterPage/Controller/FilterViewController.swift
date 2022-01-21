//
//  FilterViewController.swift
//  Skripsi AMIN
//
//  Created by Vivian Angela on 20/01/22.
//

import UIKit

class FilterViewController: UIViewController {

     // MARK: Black view
    let maxDimmedAlpha: CGFloat = 0.6
    
    lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    lazy var dimmedView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        
        return view
    }()
    
     // MARK: Constant Variable
    let defaultHeight: CGFloat = UIScreen.main.bounds.height / 2
    let dismissibleHeight: CGFloat = 200
    let maximumContentHeight: CGFloat = UIScreen.main.bounds.height - 45
    var currentHeight: CGFloat = UIScreen.main.bounds.height / 2
    
     // MARK: Dynamic Container Constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUpConstraint()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        view.addGestureRecognizer(tapGesture)
        setUpPanGesture()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentDimmedView()
        animatePresentContent()
    }

    @objc func handleCloseAction() {
        
    }

     // MARK: Set default height for contentView
    func setUpConstraint() {
        view.addSubview(dimmedView)
        view.addSubview(contentView)
        
        dimmedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        containerViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
     // MARK: Add gesture for the contentView
    func setUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture: )))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown: Bool = translation.y > 0
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContentHeight {
                containerViewHeightConstraint?.constant = newHeight
                animateContainerHeight(newHeight)
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                dismissView()
                self.tabBarController?.tabBar.isHidden = false
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContentHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContentHeight)
            }
    
        default:
            break
        }
        
    }
    
     // MARK: Animation for the containtView if dragged (smooth)
    func animateContainerHeight (_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            
             // MARK: Refresh constraint
            self.view.layoutIfNeeded()
        }
         // MARK: Save current height
        currentHeight = height
    }
    
     // MARK: Set Bottom Constraint
    func animatePresentContent() {
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func presentDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func dismissView() {
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
//            let vc = ResepViewController()
//            vc.tabBarController?.tabBar.isHidden = false
//            vc.viewDidLoad()
        }
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
}
