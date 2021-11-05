//
//  HomeViewController.swift
//  ChatApp
//
//  Created by duytran on 11/1/21.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView:UITableView!
    var ref:DatabaseReference!
    var users:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // connect to firebase db
        ref = Database.database().reference()
        setupHomeTableView()
        setupLogoutButton()
        fetchCurrentUser()
        fetchListUser()
    }
    
    private func setupHomeTableView() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        homeTableView.tableFooterView = UIView()
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func handleLogout() {
        FirebaseUserManager.shared.logoutUser { (message, authErrorCode) in
            DispatchQueue.main.async {
                Alert.shared.showMessage(title: "Đăng xuất", message: message, completion: { (action) in
                    self.transitionToLoginVC()
                }, vc: self)
            }
        }
    }
    
    private func transitionToLoginVC() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
    }
    
    private func fetchListUser() {
        FirebaseUserManager.shared.fetchListUser { (result) in
            switch result {
            case .success(let listUser):
                DispatchQueue.main.async {
                    self.users = listUser
                    self.homeTableView.reloadData()
                }
            case .failure(_):
                print("error")
            }
        }
    }
    
    private func fetchCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return }
        FirebaseUserManager.shared.fetchUserInfo(currentUserID: currentUser.uid) { (result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.title = user.displayName
                }
            case .failure(_):
                print("error")
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userItem = users[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil)
        chatVC.user = userItem
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let userItem = users[indexPath.row]
        cell.textLabel?.text = userItem.displayName
        return cell
    }
}

