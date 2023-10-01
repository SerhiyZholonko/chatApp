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
    private var conversationFielter: [Message] = []
    private let unReadMsgLabel: UILabel = {
        let label = UILabel ()
        label.text = "8"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.setDimensions(height: 40, width: 40)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "info"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.setDimensions(height: 40, width: 40)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleProfilebutton), for: .touchUpInside)
        return button
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.isHidden = true
        return view
    }()
    private let emptyLabel = CustomLabel(textLabel: "There are no conversation, Click add to start chatting now", textColorLabel: .systemYellow, numberOfLines: 2)
    private var conversations: [Message] = [] {
        didSet {
            getTotalAmount(conversations: conversations)
            emptyView.isHidden = !conversations.isEmpty
            tableView.reloadData()
        }
    }
    private var totalAmount: Int? {
        didSet {
            guard let totalAmount = totalAmount else { return }
            unReadMsgLabel.isHidden = totalAmount == 0
            DispatchQueue.main.async {[self] in
                
                unReadMsgLabel.text = "\(totalAmount)"
            }
        }
    }
    
    private var isSearchMode: Bool  {
        guard let text = searchController.searchBar.text else { return false }
        return searchController.isActive || !text.isEmpty
    }
    private var conversationDictionary = [String: Message]()
    private let searchController = UISearchController(searchResultsController: nil )
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
        configureSearchController()
        getUser()
      fetchConversations()
        configureTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserProfile), name: .userProfile, object: nil)
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
        navigationItem.title = user.username.uppercased()
        
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.identifier)
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        addConstraints()
    }
    private func configureSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search.."
        navigationItem.searchController = searchController
    }
    private func addConstraints() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
        view.addSubview(unReadMsgLabel)
        unReadMsgLabel.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 20, paddingBottom: 20)
        view.addSubview(profileButton)
        profileButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 30, paddingRight: 20)
        view.addSubview(emptyView)
        emptyView.anchor( left: view.leftAnchor, bottom: profileButton.topAnchor, right: view.rightAnchor, paddingLeft: 25, paddingBottom: 25, paddingRight: 25, height: 60)
        emptyView.addSubview(emptyLabel)
        emptyLabel.center(inView: emptyView)
        emptyLabel.anchor(left: emptyView.leftAnchor, right: emptyView.rightAnchor, paddingLeft: 5, paddingRight: 5)
    }
    private func getUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
         UserServiece.fetchUser(uid: uid) { [weak self] user in
             self?.user = user
         }
    }
    private func getTotalAmount(conversations: [Message] ) {
        var tempAmount: Int = 0
        conversations.forEach { tempAmount += $0.newMessage}
        self.totalAmount = tempAmount
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
    @objc private func handleProfilebutton() {
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc private func handleUserProfile() {
        print("Debug: observe conversation")
        UserServiece.fetchUser(uid: user.uid) { [self] currentUser in
            user = currentUser
            title = user.username
        }
    }
}



//MARK: - UITableViewDelegate,UITableViewDataSource

extension ConversationViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearchMode ? conversationFielter.count : conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.identifier, for: indexPath) as! ConversationCell
        let conversation = isSearchMode ? conversationFielter[indexPath.item] : conversations[indexPath.item]
        cell.viewModel = MessageViewModel(message: conversation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingAnimation()
        let coversation =  isSearchMode ? conversationFielter[indexPath.item] : conversations[indexPath.item]
        UserServiece.fetchUser(uid: coversation.chatPartnerID) { [self] otherUser in
            self.hideLoadingAnimation()
            self.openChatVithUser(withCurrentUser: user, withOtherUser: otherUser)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        showLoadingAnimation()
        let coversation =  isSearchMode ? conversationFielter[indexPath.item] : conversations[indexPath.item]
        UserServiece.fetchUser(uid: coversation.toID) { [self] user in
            MessageService.deleteConversation(withUser: user) {[self] error in
                if let error = error {
                    print(error.localizedDescription)
                }
                hideLoadingAnimation()
                if editingStyle == .delete {
                    if isSearchMode {
                        conversationFielter.remove(at: indexPath.row)
                    } else {
                        conversations.remove(at: indexPath.row)
                    }
                    
                    tableView.reloadRows(at: [indexPath], with: .fade)

                }
            }
        }
     
    
    }
}


//MARK: - NewChatvitwControllerDelegate
extension ConversationViewController: NewChatvitwControllerDelegate {
    func controller(_ vc: NewChatViewController, wantChatwithUser otherUser: User) {
        vc.dismiss(animated: true)
        openChatVithUser(withCurrentUser: user, withOtherUser: otherUser)
    }
    
    
}


 //MARK: - SearchViewController
extension ConversationViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {        
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        conversationFielter = conversations.filter{$0.username.contains(searchText) || $0.fullName.contains(searchText)}
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = nil
        searchBar.showsCancelButton = false
    }
}
