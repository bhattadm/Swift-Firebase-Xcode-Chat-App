//
//  AuthService.swift
//  Chat
//
//  Created by Megha Bhattad on 4/21/21.
//

import Foundation
import Firebase
import UIKit

struct RegistrationCredentials{
    let email: String
    let password: String
    let fullname: String
    let username:String
    let profileImage:UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion:  AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials:RegistrationCredentials,completion: ((Error?)-> Void)?){
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        ref.putData(imageData, metadata: nil){(meta, error) in
            if let error = error{
//                print("Failed to uplaod image with error \(error.localizedDescription)")
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) {(result,error) in
                    if let error = error{
//                        print("Failed to create user with error \(error.localizedDescription)")
                        completion!(error)
                    }
                    guard let uid = result?.user.uid else {return}
                    let data = ["email": credentials.email,
                                "fullname": credentials.fullname,
                                "profileImageUrl":profileImageUrl,
                                "uid":uid,
                                "username":credentials.username] as [String:Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                    
                }
            }
        }
       
    }
    
}
