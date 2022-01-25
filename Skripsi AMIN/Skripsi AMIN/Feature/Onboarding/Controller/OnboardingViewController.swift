//
//  OnboardingViewController.swift
//  Cuoco
//
//  Created by Vivian Angela on 26/01/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingCollection: UICollectionView!
    @IBOutlet weak var onboardingPageController: UIPageControl!
    @IBOutlet weak var onboardingBtn: UIButton!
    
    let onboardingContent = ["Onboarding1", "Onboarding2", "Onboarding3", "Onboarding4"]
    
    var currentIndex = 0 {
        didSet {
            onboardingPageController.currentPage = currentIndex
            
            if currentIndex == onboardingContent.count - 1 {
                onboardingBtn.setTitle("Mulai Sekarang", for: .normal)
                onboardingBtn.tintColor = .white
                onboardingBtn.backgroundColor = UIColor(named: "PrimaryColor")
                onboardingBtn.layer.cornerRadius = 13
            }
            else {
                onboardingBtn.setTitle("Lanjutkan", for: .normal)
                onboardingBtn.tintColor = UIColor(named: "PrimaryColor")
                onboardingBtn.backgroundColor = .clear
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    @IBAction func didNextBtnTap(_ sender: UIButton) {
        if currentIndex ==  3 {
            self.dismiss(animated: true, completion: nil)
            OnboardingState.shared.setIsNotNewUser()
        }
        else {
            currentIndex += 1
            let indexPath = IndexPath(item: currentIndex, section: 0)
            onboardingCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        print(currentIndex)
    }
    
    func setUp() {
        onboardingCollection.register(UINib(nibName: "\(OnboardingCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "onboardingCollectionCell")
        onboardingCollection.delegate = self
        onboardingCollection.dataSource = self
        
        onboardingBtn.setTitle("Lanjutkan", for: .normal)
        onboardingBtn.tintColor = UIColor(named: "PrimaryColor")
        onboardingBtn.backgroundColor = .clear
        
        onboardingPageController.pageIndicatorTintColor = UIColor(named: "SecondaryTintColor")
        onboardingPageController.currentPageIndicatorTintColor = UIColor(named: "PrimaryColor")
    }


}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onboardingCollection.dequeueReusableCell(withReuseIdentifier: "onboardingCollectionCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.image = onboardingContent[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: onboardingCollection.frame.width, height: onboardingCollection.frame.height)
    }
    
     // MARK: To make current scrollview center when scroll
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentIndex = Int(scrollView.contentOffset.x / width)
    }
    
}
