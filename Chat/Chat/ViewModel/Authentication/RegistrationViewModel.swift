//
//  File.swift
//  Chat
//
//  Created by Megha Bhattad on 4/21/21.
//

import Foundation

struct RegistrationViewModel {
    var fullname: String?
    var username: String?
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
       var val =    fullname?.isEmpty == false
                &&  username?.isEmpty == false
                &&  email?.isEmpty    == false
               // && password?.isEmpty  == false

        print(val)
        return val
    }
}
