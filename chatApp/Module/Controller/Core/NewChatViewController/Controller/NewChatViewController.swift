//
//  NewChatViewController.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

protocol NewChatvitwControllerDelegate: AnyObject{
    func controller(_ vc: NewChatViewController, wantChatwithUser otherUser: User)
}
class NewChatViewController: UIViewController, UIAnimatable {
    //MARK: - Properties
    weak var delegate: NewChatvitwControllerDelegate?
    private let searchController = UISearchController(searchResultsController: nil )
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.isHidden = true
        return view
    }()
    private let emptyLabel = CustomLabel(textLabel: "There are no conversation, Click add to start chatting now", textColorLabel: .systemYellow, numberOfLines: 2)
    private var isSearchMode: Bool  {
        guard let text = searchController.searchBar.text else { return false }
        return searchController.isActive || !text.isEmpty
    }
    let tableView = UITableView()
    private var users = [User]()  {
        didSet {
            emptyView.isHidden = !users.isEmpty
        }
    }
    private var usersFielter: [User] = []{
        didSet {
            emptyView.isHidden = !usersFielter.isEmpty
        }
    }

    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureSearchController()
        getUsers()
    }
    
    //MARK: - Functions
    private func getUsers() {
        showLoadingAnimation()
        UserServiece.fetchUsers {[weak self] users in
            DispatchQueue.main.async {
                self?.users = users
                self?.tableView.reloadData()
                self?.hideLoadingAnimation()
            }
        }
    }
    private func configureUI() {
        title = "SEARCH"
        navigationItem.leftBarButtonItem = .init(image: UIImage(named: "cancel"), style: .done, target: self, action: #selector(handleDismiss))
        view.backgroundColor = .systemBackground
        addConstraints()
    }
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewChatCell.self, forCellReuseIdentifier: NewChatCell.identifier)
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView()
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
        view.addSubview(emptyView)
        emptyView.anchor( left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 25, paddingBottom: 25, paddingRight: 25, height: 60)
        emptyView.addSubview(emptyLabel)
        emptyLabel.center(inView: emptyView)
        emptyLabel.anchor(left: emptyView.leftAnchor, right: emptyView.rightAnchor, paddingLeft: 5, paddingRight: 5)
    }
    @objc private func handleDismiss() {
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource

extension NewChatViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearchMode ? usersFielter.count : users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewChatCell.identifier, for: indexPath) as! NewChatCell
        let user = isSearchMode ? usersFielter[indexPath.row] : users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.item]
        delegate?.controller(self, wantChatwithUser: user)
    }
}


//MARK: - SearchViewController
extension NewChatViewController: UISearchResultsUpdating, UISearchBarDelegate {
   func updateSearchResults(for searchController: UISearchController) {       
       guard let searchText = searchController.searchBar.text?.lowercased() else { return }
       usersFielter = users.filter{$0.fullname.contains(searchText) || $0.username.contains(searchText)}
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
