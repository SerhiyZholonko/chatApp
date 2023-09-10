//
//  SceneDelegate.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        configureInitialviewControlr()
    }

    
    func configureInitialviewControlr() {
     
        let loginVC = LoginViewController()
        if let uid = Auth.auth().currentUser?.uid {
            UserServiece.fetchUser(uid: uid) { [weak self] user in
                let conversationVC = ConversationViewController(user: user)
                let nav = UINavigationController(rootViewController: conversationVC)
                self?.window?.rootViewController = nav
            }
            
        } else {
            let nav = UINavigationController(rootViewController: loginVC)
            self.window?.rootViewController = nav
        }
        window?.makeKeyAndVisible()
    }
}

