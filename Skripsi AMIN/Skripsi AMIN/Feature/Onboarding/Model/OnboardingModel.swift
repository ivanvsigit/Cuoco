//
//  OnboardingModel.swift
//  Cuoco
//
//  Created by Vivian Angela on 26/01/22.
//

import Foundation
import UIKit

struct OnboardingModel {
    var image: UIImage
}

struct OnboardingState {
    static var shared = OnboardingState()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "newUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.setValue(true, forKey: "newUser")
    }
}
