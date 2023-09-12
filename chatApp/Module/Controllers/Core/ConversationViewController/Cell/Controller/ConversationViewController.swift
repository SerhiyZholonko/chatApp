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
    
    private let tableView = UITableView()

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
        configureNavBar()
        getUser()
       print(user.username)
        configureTableView()
    }
   
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        navigationBarConfigure()
     }
    //MARK: - Functions
    private  func configureNavBar() {
        view.backgroundColor = .systemBackground
        let signOutButton = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(handleSignOut))

        let newConversationBarButton = UIBarButtonItem(image: UIImage(named: "copy-writing"), style: .plain, target: self, action: #selector(handleNewChat))

        navigationItem.leftBarButtonItem = signOutButton
        navigationItem.rightBarButtonItem = newConversationBarButton
        if let navigationBar = navigationController?.navigationBar {
            if let boldFont = UIFont(name: "Avanir-Bold", size: 30) {
                navigationBar.setTitleFont(boldFont, color: UIColor.black)
            }
        }
        navigationItem.title = "CHAT APP"
        
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifier)
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        addConstraints()
    }
    private func addConstraints() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
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
    @objc private func handleSignOut() {
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
    @objc private func handleNewChat() {
        let vc = NewChatViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}



//MARK: - UITableViewDelegate,UITableViewDataSource

extension ConversationViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
