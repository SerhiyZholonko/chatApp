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
    let tableView = UITableView()
    private var users = [User]()
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
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
    private func addConstraints() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 15, paddingRight: 15)
    }
    @objc private func handleDismiss() {
        dismiss(animated: true)
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource

extension NewChatViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewChatCell.identifier, for: indexPath) as! NewChatCell
        let user = users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = users[indexPath.item]
        delegate?.controller(self, wantChatwithUser: user)
    }
}
