//
//  ConversationController.swift
//  Chat
//
//  Created by Megha Bhattad on 4/20/21.
//

import Foundation
import UIKit
import Firebase

private let resuseIdentifier = "ConversationCell"


//MARK: -Lifecycle
class ConversationsCntroller: UIViewController{
    
    //MARK: -Properties
    private let tableView =  UITableView()
    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName:"plus"),for: .normal)
        button.backgroundColor = .systemTeal
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
        fetchConversations()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
//    }
    
    // Mark: -Selector
    @objc func showProfile(){
        logout()
    }
    
    //MARk: -- API
    func authenticateUser(){
        if  Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("User id is \(Auth.auth().currentUser?.uid)")
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
        }catch{
            print("Error while logging out")
        }
    }
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
           controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func showNewMessage(){
        let controller =  NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func fetchConversations() {
        Service.fetchConversations { conversations in
//            self.conversations = conversations
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    //MARK: -helper
    func configureUI(){
        view.backgroundColor = .white
        
       configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56/2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: resuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
//    func configureNavigationBar(){
//        let appearence  = UINavigationBarAppearance()
//        appearence.configureWithOpaqueBackground()
//        appearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        appearence.backgroundColor = .systemTeal
//        
//        navigationController?.navigationBar.standardAppearance   = appearence
//        navigationController?.navigationBar.compactAppearance    = appearence
//        navigationController?.navigationBar.scrollEdgeAppearance = appearence
//        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.title = "Messages"
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
//    }
}

extension ConversationsCntroller: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversations[indexPath.row]
//        cell.textLabel?.text = conversations[indexPath.row].message.text
        return cell
    }
    
    
}
// MARK:-- UITableViewDelegate
extension ConversationsCntroller: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK:-- NewMessageControllerDelegate
extension ConversationsCntroller: NewMessageControllerDelegate{
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true, completion: nil)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}

// MARK:-- ConversationControlDelegate
extension ConversationsCntroller: AuthenticationDelegate{

    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchConversations()
    }

}
