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
    @IBOutlet weak var bottomContainerViewAnchor: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginAndRegisterButton()
        setupTextField()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handletextField))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handletextField() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    @objc private func handleKeyBoard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomContainerViewAnchor.constant = isKeyboardShowing ? (keyboardFrame.height + 0) : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func transitionToHomeVC() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navBar = UINavigationController(rootViewController: homeVC)
        self.view.window?.rootViewController = navBar
        self.view.window?.makeKeyAndVisible()
    }
    
    private func setupTextField() {
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.masksToBounds = true
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
