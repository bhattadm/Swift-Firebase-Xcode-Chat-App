//
//  LoginController.swift
//  Chat
//
//  Created by Megha Bhattad on 4/21/21.
//

import Foundation
import UIKit

//protocol AuthenticationControllerProtocol {
//    var checkFormStatus: Bool{ get }
//}
class LoginController: UIViewController{
    // MARK: -- Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
//        let containerView = UIView()
//        containerView .backgroundColor = .clear
//
//        let iv = UIImageView()
//        iv.image = UIImage(systemName: "envelope")
//        iv.tintColor = .white
//        containerView .addSubview(iv)
//        iv.centerY(inView: containerView)
//        iv.anchor(left: containerView.leftAnchor , paddingLeft: 8)
//        iv.setDimensions(height: 24, width: 28)
//
//        containerView.addSubview(emailTextField)
//        emailTextField.centerY(inView: containerView)
//        emailTextField.anchor(left: iv.rightAnchor , bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 8, paddingBottom: -8)
//        iv.setDimensions(height: 28, width: 28)
//
//        containerView .setHeight(height: 50)
//        return containerView
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        let containerView = InputContainerView(image: image,                                                                   textField: emailTextField)
       
        return containerView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
//        let containerView = InputContainerView(image: UIImage(systemName: "lock"),                                            textField: passwordTextField)
        let containerView = InputContainerView(image:#imageLiteral(resourceName: "ic_lock_outline_white_2x"),textField: passwordTextField)
//
        return containerView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 35)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
//    private let emailTextField: UITextField = {
//        let emailtxt = UITextField()
//        emailtxt.placeholder = "Email"
//        emailtxt.textColor = .white
//        return emailtxt
//    }()
    
    private let emailTextField = CustomTextField(placeholder:"Email")
    
    private var passwordTextField: CustomTextField {
        let passwordtxt = CustomTextField(placeholder: "Password")
        
        
        //passwordtxt.textContentType = .newPassword
       // passwordtxt.clearsOnBeginEditing = false
        passwordtxt.isSecureTextEntry = true
        return passwordtxt
    }
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have account? " ,
                            attributes: [.font: UIFont.systemFont(ofSize: 16),
                                         .foregroundColor:UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up" ,
                        attributes: [.font: UIFont.boldSystemFont(ofSize: 16),
                                     .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
           
        return button
    }()
    //MARK: -- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: -- Selector
    @objc func handleShowSignUp(){
        let controller =  RegistrationController()
        navigationController?.pushViewController(controller, animated:true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            print("I am here")
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleLogin(){
        print("Hello1")
    }
    
    //MARK:-- Helper
    
    func checkFormStatus(){
        if viewModel.formIsValid {
            print("Hello2");
            loginButton.isEnabled  = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            print("Hello1");
            loginButton.isEnabled  = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
    }
    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews:[emailContainerView,
                                                  passwordContainerView,
                                                  loginButton])
            
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingLeft: 32, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
    
}

//extension LoginController: AuthenticationControllerProtocol{
//    
//}
