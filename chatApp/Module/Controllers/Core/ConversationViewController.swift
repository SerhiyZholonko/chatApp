//
//  ConversationViewController.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit
import Firebase



class ConversationViewController: UIViewController {
    //MARK: - Properties
    
    private var user: User
    
    //MARK: - Livecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getUser()
       print(user.username)
    }
   
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        navigationBarConfigure()
     }
    //MARK: - Functions
    private  func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = .init(title: "SignOut", style: .plain, target: self, action: #selector(signOut))
    }
    private func getUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
         UserServiece.fetchUser(uid: uid) { [weak self] user in
             self?.user = user
         }
    }
    private func navigationBarConfigure() {
        // Disable the back indicator image for this view controller
               navigationController?.navigationBar.backIndicatorImage = nil
               navigationController?.navigationBar.backIndicatorTransitionMaskImage = nil
               
               // Adjust the back button title position
               let backButtonImage = UIImage() // Create an empty UIImage
               navigationController?.navigationBar.backIndicatorImage = backButtonImage
               navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage

    }
    @objc private func signOut() {
        AuthService.signOut{ error in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            let scene = UIApplication.shared.connectedScenes.first
                  if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate){
                      sd.configureInitialviewControlr()
                  }
        }
       
    }
}
