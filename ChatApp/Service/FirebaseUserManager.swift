//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by duytran on 11/4/21.
//

import UIKit
import Firebase
import FirebaseAuth

class FirebaseUserManager {
    static var shared = FirebaseUserManager()
    private var ref : DatabaseReference!
    private init() {
        ref = Database.database().reference()
    }
    
    public func loginUser(email:String, password:String, completion: @escaping((String, AuthErrorCode?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: error.code) else { return }
                switch errorCode {
                case .invalidEmail:
                    completion("Email không hợp lệ. Vui lòng nhập đúng định dạng email", .invalidEmail)
                    break
                case .wrongPassword:
                    completion("Sai mật khẩu. Vui lòng nhập đúng mật khẩu của bạn", .wrongPassword)
                    break
                default:
                    break
                }
            } else {
                completion("Đăng nhập thành công", nil)
            }
        }
    }
    
    public func registerUser(displayName:String, email:String, password:String, completion: @escaping((String, AuthErrorCode?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error as NSError? {
                guard let errorCode = AuthErrorCode(rawValue: error.code) else { return }
                switch errorCode {
                case .invalidEmail:
                    completion("Email không hợp lệ. Vui lòng nhập đúng định dạng email", .invalidEmail)
                    break
                case .weakPassword:
                    completion("Mật khẩu của bạn quá yếu. Vui lòng thử mật khẩu mạnh hơn", .weakPassword)
                    break
                default:
                    break
                }
            } else {
                guard let currentUser = Auth.auth().currentUser else { return }
                let userData = ["id": currentUser.uid, "displayName": displayName, "email": email]
                self.ref.child("Users").childByAutoId().setValue(userData)
                completion("Đăng ký thành công", nil)
            }
        }
    }
    
    public func logoutUser(completion: @escaping((String, AuthErrorCode?) -> Void)) {
        do {
            try Auth.auth().signOut()
            completion("Đăng xuất thành công", nil)
        } catch let error {
            completion(error.localizedDescription, nil)
        }
    }
    
    public func fetchListUser(completion: @escaping((Result<[User], Error>) -> Void)) {
        guard let currentUser = Auth.auth().currentUser else { return }
        ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            var users:[User] = []
            for child in snapshot.children {
                let userSanpshot = child as! DataSnapshot
                let userDict = userSanpshot.value as! [String:Any]
                let userID = userDict["id"] as! String
                let email = userDict["email"] as! String
                let displayName = userDict["displayName"] as! String
                let user = User(id: userID, displayName: displayName, email: email)
                if currentUser.uid != user.id {
                    users.append(user)
                }
            }
            completion(.success(users))
        }
    }
    
    public func fetchUserInfo(currentUserID:String, completion: @escaping((Result<User, Error>) -> Void)) {
        ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let userSanpshot = child as! DataSnapshot
                let userDict = userSanpshot.value as! [String:Any]
                let userID = userDict["id"] as! String
                let email = userDict["email"] as! String
                let displayName = userDict["displayName"] as! String
                
                if  userID == currentUserID {
                    let user = User(id: currentUserID, displayName: displayName, email: email)
                    completion(.success(user))
                }
            }
        }
    }
}
