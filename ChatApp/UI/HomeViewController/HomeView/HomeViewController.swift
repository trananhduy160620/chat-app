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
    private var titleBar = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // connect to firebase db
        ref = Database.database().reference()
        setupHomeTableView()
        setupLogoutButton()
        fetchUsersInfo()
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
        do {
            try Auth.auth().signOut()
            transitionToLoginVC()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    private func transitionToLoginVC() {
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
    }
    
    private func fetchUsersInfo() {
        guard let currentUser = Auth.auth().currentUser else { return }
        ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let userSanpshot = child as! DataSnapshot
                let userDict = userSanpshot.value as! [String:Any]
                let userID = userDict["id"] as! String
                let email = userDict["email"] as! String
                let displayName = userDict["displayName"] as! String
                let user = User(id: userID, displayName: displayName, email: email)
                if currentUser.uid != user.id {
                    self.users.append(user)
                } else {
                    self.titleBar = user.displayName
                }
            }
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
                self.title = self.titleBar
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

