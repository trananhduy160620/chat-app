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
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupButton()
        setupTextField()
        addKeyboardObserver()
        addTapGestureRecognizer()
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addTapGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handletextField))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handletextField() {
        displayNameTextField.endEditing(true)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
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
    
    private func setupTextField() {
        displayNameTextField.layer.cornerRadius = 8
        displayNameTextField.layer.borderWidth = 1.5
        displayNameTextField.layer.borderColor = UIColor.darkGray.cgColor
        displayNameTextField.layer.masksToBounds = true
        
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.borderColor = UIColor.darkGray.cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.masksToBounds = true
    }
    
    private func setupButton() {
        registerButton.layer.cornerRadius = 10
        registerButton.layer.masksToBounds = true
        
        goBackButton.layer.cornerRadius = 10
        goBackButton.layer.masksToBounds = true
    }
    
    @IBAction func registerButtonClick(_ sender: UIButton)
    {
        guard let displayName = displayNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FirebaseUserManager.shared.registerUser(displayName: displayName, email: email, password: password)
        { (message, authErrorCode) in
            DispatchQueue.main.async {
                switch authErrorCode {
                case .invalidEmail:
                    Alert.shared.showMessage(title: "Thông báo", message: message, vc: self)
                case .weakPassword:
                    Alert.shared.showMessage(title: "Thông báo", message: message, vc: self)
                default:
                    Alert.shared.showMessage(title: "Đăng ký", message: message, completion: { (action) in
                        self.transitionToHomeVC()
                    }, vc: self)
                }
            }
        }
    }
    
    @IBAction func goBackButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func transitionToHomeVC() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navBar = UINavigationController(rootViewController: homeVC)
        self.view.window?.rootViewController = navBar
        self.view.window?.makeKeyAndVisible()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

