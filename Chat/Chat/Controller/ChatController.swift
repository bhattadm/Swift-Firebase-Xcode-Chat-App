//
//  ChatController.swift
//  Chat
//
//  Created by Megha Bhattad on 4/22/21.
//

import Foundation
import UIKit

private let resuseIdentifier = "MessageCell"

class ChatController: UICollectionViewController{
    
    //MARK: -- Property
    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //MARK: -- Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView?{
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: -- API
    func fetchMessages() {
        Service.fetchMessages(forUser: user) { messages in
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count-1], at: .bottom, animated: true)
        }
    }
    
    //MARK: -- Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: resuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifier, for: indexPath)
            as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 30) //height 50
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_inputView inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        Service.uploadMessage(message, to: user) { error in
            if let error = error{
                print("Failed to Upload Messages \(error.localizedDescription)")
                return
            }
            inputView.clearMessageText()
        }
        
    }
    
    
}
