//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by duytran on 10/28/21.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupRegisterButton()
    }
    
    private func setupRegisterButton() {
        registerButton.layer.cornerRadius = 20
        registerButton.layer.masksToBounds = true
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton)
    {
        guard let displayName = displayNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil { print(error?.localizedDescription ?? "") }
            guard let currentUser = Auth.auth().currentUser else { return }
            let userData = ["id": currentUser.uid, "displayName": displayName, "email": email]
            // add new user to firebase db
            self.ref.child("Users").childByAutoId().setValue(userData)
             // transition to chat vc
            self.transitionToChatVC()
        }
    }
    
    private func transitionToChatVC() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navBar = UINavigationController(rootViewController: homeVC)
        self.view.window?.rootViewController = navBar
        self.view.window?.makeKeyAndVisible()
    }
}

