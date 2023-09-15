//
//  ConversationViewController.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit
import Firebase



class ConversationViewController: UIViewController, UIAnimatable {
    //MARK: - Properties
    private var user: User
    private let tableView = UITableView()
    private var conversations: [Message] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var conversationDictionary = [String: Message]()
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
      fetchConversations()
        configureTableView()
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

    private func openChatVithUser(withCurrentUser currentUser: User, withOtherUser otherUser: User) {
        let vc = ChatViewController(otherUser: otherUser, currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
    private func fetchConversations (){
        MessageService.fetchRecentMessages { conversations in
            conversations.forEach { conversation in
                self.conversationDictionary[conversation.chatPartnerID] = conversation
            }
            self.conversations = Array(self.conversationDictionary.values)
        }
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
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}



//MARK: - UITableViewDelegate,UITableViewDataSource

extension ConversationViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        let conversation = conversations[indexPath.item]
        cell.viewModel = MessageViewModel(message: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingAnimation()
        let coversation = conversations[indexPath.item]
        UserServiece.fetchUser(uid: coversation.chatPartnerID) { [self] otherUser in
            self.hideLoadingAnimation()
            self.openChatVithUser(withCurrentUser: user, withOtherUser: otherUser)
        }
    }
    
    
}


//MARK: -
extension ConversationViewController: NewChatvitwControllerDelegate {
    func controller(_ vc: NewChatViewController, wantChatwithUser otherUser: User) {
        vc.dismiss(animated: true)
        openChatVithUser(withCurrentUser: user, withOtherUser: otherUser)
    }
    
    
}
