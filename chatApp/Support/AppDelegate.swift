//
//  AppDelegate.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setingNavBar()
        return true
    }
    private func setingNavBar() {
        UINavigationBar.appearance().tintColor = .label
                let backImg = UIImage (named: "chevron.backward")
                UINavigationBar.appearance().backIndicatorImage = backImg
                UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
                UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(.init(horizontal: -1000, vertical: 0), for: .default)
                UITableView.appearance().tintColor = .white
                UITabBar.appearance().barTintColor = UIColor.black
    }



}

