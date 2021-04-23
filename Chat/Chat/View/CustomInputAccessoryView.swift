//
//  CustomInputAccessoryView.swift
//  Chat
//
//  Created by Megha Bhattad on 4/22/21.
//

import Foundation
import UIKit

protocol  CustomInputAccessoryViewDelegate: class {
    func inputView(_inputView: CustomInputAccessoryView, wantsToSend message:String)
}
class CustomInputAccessoryView: UIView {
    
    // MARK: -- Property
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private lazy var messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemTeal, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placholderLabel : UILabel = {
        let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: -- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,right: sendButton.leftAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 10, paddingRight: 8)
        
        addSubview(placholderLabel)
        placholderLabel.anchor(left: messageInputTextView.leftAnchor, paddingLeft: 4)
        placholderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: -- Selector
    @objc func handleSendMessage() {
        guard let message = messageInputTextView.text else { return }
        delegate?.inputView(_inputView: self, wantsToSend: message)
    }
    @objc func handleTextInputChange() {
        placholderLabel.isHidden  = !self.messageInputTextView.text.isEmpty
    }
    
    
    // MARK: -- Helpers
    func clearMessageText(){
        messageInputTextView.text = nil;
        placholderLabel.isHidden = false
    }
}
