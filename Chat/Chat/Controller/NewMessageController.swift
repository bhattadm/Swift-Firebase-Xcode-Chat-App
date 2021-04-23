//
//  NewMessageController.swift
//  Chat
//
//  Created by Megha Bhattad on 4/22/21.
//

import Foundation
import UIKit

private let resuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: UITableViewController{
    
    // MARk :-- Property
    private var users = [User]()
    weak var delegate: NewMessageControllerDelegate?
    
    //MARK: : --LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    // MARK: -- Selector
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    //MARK: -- API
    func fetchUsers(){
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARk: : -- Helper
    func configureUI(){
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: resuseIdentifier)
        tableView.rowHeight = 80
    }
    
}
// Mark : -- UITableViewDataSource
extension NewMessageController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}

extension NewMessageController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
}

