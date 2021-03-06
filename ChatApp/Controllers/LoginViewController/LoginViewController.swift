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
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginAndRegisterButton()
        setupTextField()
        addKeyboardObserver()
        addTapGestureRecognizer()
        
    }
    
    private func addTapGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handletextField))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handletextField() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyBoard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            var contentInset = self.scrollView.contentInset
            if isKeyboardShowing {
                contentInset.bottom = keyboardFrame.height
                self.scrollView.contentInset = contentInset
            } else {
                self.scrollView.contentInset = UIEdgeInsets.zero
            }
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func transitionToHomeVC() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navBar = UINavigationController(rootViewController: homeVC)
        self.view.window?.rootViewController = navBar
        self.view.window?.makeKeyAndVisible()
    }
    
    private func setupTextField() {
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.masksToBounds = true
        emailTextField.delegate = self
        emailTextField.tag = 0
        
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.masksToBounds = true
        passwordTextField.delegate = self
        passwordTextField.tag = 1
    }
    
    private func setupLoginAndRegisterButton() {
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
    }
    
    @IBAction func loginButtonClick(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FirebaseUserManager.shared.loginUser(email: email, password: password) { (message, authErrorCode) in
            DispatchQueue.main.async {
                switch authErrorCode {
                case .invalidEmail:
                    Alert.shared.showMessage(title: "Th??ng b??o", message: message, vc: self)
                case .wrongPassword:
                    Alert.shared.showMessage(title: "Th??ng b??o", message: message, vc: self)
                default:
                    Alert.shared.showMessage(title: "????ng nh???p", message: message, completion: { (action) in
                        self.transitionToHomeVC()
                    }, vc: self)
                }
            }
        }
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        let registerVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.present(registerVC, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
        } else {
           // Not found, so remove keyboard.
           textField.resignFirstResponder()
        }
      // Do not add a line break
      return false
    }
}
