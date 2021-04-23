//
//  RegistrationController.swift
//  Chat
//
//  Created by Megha Bhattad on 4/21/21.
//

import Foundation
import UIKit
import Firebase

class RegistrationController: UIViewController{
    // MARK: -- Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage:UIImage?
    weak var delegate: AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
       // button.imageView?.clipsToBounds = true
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
    
    private let passwordTextField: CustomTextField = {
        let passwordtxt = CustomTextField(placeholder: "Password")
        
        
        //passwordtxt.textContentType = .newPassword
       // passwordtxt.clearsOnBeginEditing = false
        passwordtxt.isSecureTextEntry = true
        return passwordtxt
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
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
    
    @objc func handleRegistration(){
        guard  let fullname = fullnameTextField.text else {return}
        guard  let username = usernameTextField.text?.lowercased() else {return}
        guard  let email = emailTextField.text else {return}
        guard  let password = passwordTextField.text else {return}
        guard  let profileImage = profileImage else {return}
        
        let creditionals = RegistrationCredentials(email: email, password: password,
        fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true, withText: "Signing in")
        
        AuthService.shared.createUser(credentials: creditionals) { error in
            if let error = error{
                //print("Error: \(error.localizedDescription)")
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            self.showLoader(false)
            self.delegate?.authenticationComplete()
           //self.dismiss(animated: true, completion: nil)
        }
      
    }
    
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
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 88
        }
    }
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    // Mark: -- Helper
    func checkFormStatus(){
        if viewModel.formIsValid {
            signUpButton.isEnabled  = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        } else {
            signUpButton.isEnabled  = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
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
    
    

