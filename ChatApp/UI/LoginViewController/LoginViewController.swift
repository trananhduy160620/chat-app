//
//  LoginViewController.swift
//  ChatApp
//
//  Created by duytran on 10/28/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginAndRegisterButton()
    }
    
    private func transitionToHomeVC() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navBar = UINavigationController(rootViewController: homeVC)
        self.view.window?.rootViewController = navBar
        self.view.window?.makeKeyAndVisible()
    }
    
    private func setupLoginAndRegisterButton() {
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        
        registerButton.layer.cornerRadius = 20
        registerButton.layer.masksToBounds = true
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil { print(error?.localizedDescription ?? "") }
            self.transitionToHomeVC()
        }
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.present(registerVC, animated: true)
    }
}
