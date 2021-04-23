//
//  LoginViewModel.swift
//  Chat
//
//  Created by Megha Bhattad on 4/21/21.
//

import Foundation

//protocol AuthenticationProtocol {
//    var formIsValid: Bool{ get }
//}
struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
       var val = email?.isEmpty == false
            && password?.isEmpty == false
        return val
    }
}
