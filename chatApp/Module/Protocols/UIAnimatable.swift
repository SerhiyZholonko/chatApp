//
//  UIAnimatable.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit
import ProgressHUD
//https://github.com/relatedcode/ProgressHUD/tree/master


protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
    func succeedLoadingAnimation()
    func errorLoadingAnimation(error: String)
}

extension UIAnimatable {
    func showLoadingAnimation() {
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
    }
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    func succeedLoadingAnimation() {
        DispatchQueue.main.async {
            ProgressHUD.colorAnimation = .systemGreen
            ProgressHUD.showSucceed("Success!", delay: 1.5)
        }
    }
    func errorLoadingAnimation(error: String) {
        DispatchQueue.main.async {
            ProgressHUD.colorAnimation = .systemRed
            ProgressHUD.showFailed(error)
        }
    }
}
