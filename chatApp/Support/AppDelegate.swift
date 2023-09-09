//
//  AppDelegate.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        navBarConfigure()
        firebaseConfigure()
        return true
    }
    private func firebaseConfigure() {
        FirebaseApp.configure()
    }
    private func navBarConfigure() {
        UINavigationBar.appearance().tintColor = .label
        let backImg = UIImage (named: "chevron.backward")
        UINavigationBar.appearance().backIndicatorImage = backImg
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(.init(horizontal: -1000, vertical: 0), for: .default)
        UITableView.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = UIColor.black
    }
    
    
    
}

