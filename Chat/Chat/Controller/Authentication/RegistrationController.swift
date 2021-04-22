//
//  RegistrationController.swift
//  Chat
//
//  Created by Megha Bhattad on 4/21/21.
//

import Foundation
import UIKit

class RegistrationController: UIViewController{
    // MARK: -- Properties
    
    private var viewModel = RegistrationViewModel()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.clipsToBounds = true
        button.imageView?.clipsToBounds = true
        return button
    }()
    
    private lazy var fullNameContainerView: InputContainerView = {
        let containerView = InputContainerView(image:#imageLiteral(resourceName: "ic_person_outline_white_2x"),textField: fullnameTextField)
        return containerView
    }()
    
    private lazy var userNameContainerView: InputContainerView = {
        let containerView = InputContainerView(image:#imageLiteral(resourceName: "ic_person_outline_white_2x"),textField: usernameTextField)
        return containerView
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        let containerView = InputContainerView(image: image,                                                                   textField: emailTextField)
       
        return containerView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        let containerView = InputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
        return containerView
    }()
    
    private let fullnameTextField = CustomTextField(placeholder:"Full Name")
    
    private let usernameTextField = CustomTextField(placeholder:"Username")
    
    private let emailTextField = CustomTextField(placeholder:"Email")
    
    private var passwordTextField: CustomTextField {
        let passwordtxt = CustomTextField(placeholder: "Password")
        passwordtxt.isSecureTextEntry = true
        return passwordtxt
    }
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.setHeight(height: 50)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? " ,
                            attributes: [.font: UIFont.systemFont(ofSize: 16),
                                         .foregroundColor:UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: "Log in" ,
                        attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                     .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
           
        return button
    }()
    //MARK: -- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    
    // MARK: -- Selector
    
    @objc func textDidChange(sender: UITextField){
        if sender == fullnameTextField {
            viewModel.fullname = sender.text
        }else if sender == usernameTextField {
            viewModel.username = sender.text
        }else if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    @objc func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    // Mark: -- Helper
    func checkFormStatus(){
        if viewModel.formIsValid {
            signUpButton.isEnabled  = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            signUpButton.isEnabled  = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
    }
   
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        plusPhotoButton.setDimensions(height: 100, width: 100)
        
        let stack = UIStackView(arrangedSubviews:[fullNameContainerView,
                                                  userNameContainerView,
                                                  emailContainerView,
                                                  passwordContainerView,
                                                  signUpButton
                                                  ])
            
        stack.axis = .vertical
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingLeft: 32, paddingRight: 32)
        
        
    }
    
    func configureNotificationObserver(){
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 100 / 2
        
      
        
        dismiss(animated: true, completion: nil)
    }
}
//extension RegistrationController: AuthenticationControllerProtocol{
//    var checkFormStatus: Bool {
//        <#code#>
//    }
    
    

