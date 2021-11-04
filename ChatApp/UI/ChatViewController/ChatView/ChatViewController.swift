//
//  ChatViewController.swift
//  ChatApp
//
//  Created by duytran on 10/26/21.
//

import UIKit
import FirebaseAuth
import Firebase

class ChatViewController: UIViewController {
    @IBOutlet weak var chatMessageTableview: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var bottomContainerView: NSLayoutConstraint!
    var chatMessages:[Message] = []
    var ref:DatabaseReference!
    var user:User?
    var type:DataEventType = .value
    var newTextMessage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // outlets
        setupNavigationBar()
        setupSendMessageButton()
        setupChatTableView()
        // handle keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        fetchChatOfUser(type: type) { (result) in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.chatMessages = messages
                    self.chatMessageTableview.reloadData()
                    if self.chatMessages.count != 0 {
                        let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                        self.chatMessageTableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            case .failure(_):
                print("error")
            }
        }
    }
    
    // MARK: - Set up outlets
    private func setupNavigationBar() {
        if let user = user {
            self.navigationItem.title = user.displayName
            self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
            self.navigationController?.navigationBar.backgroundColor = UIColor.systemGreen
        }
    }
    
    private func setupSendMessageButton() {
        let sendImage = UIImage(systemName: "paperplane.fill")
        sendMessageButton.setImage(sendImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        sendMessageButton.layer.cornerRadius = 5
        sendMessageButton.layer.masksToBounds = true
    }
    
    private func setupChatTableView() {
        chatMessageTableview.delegate = self
        chatMessageTableview.dataSource = self
        chatMessageTableview.separatorStyle = .none
        let nibCell = UINib(nibName: "ChatMessageCell", bundle: nil)
        chatMessageTableview.register(nibCell, forCellReuseIdentifier: "ChatMessageCell")
    }
    
    // MARK: - Set up actions
    @IBAction func sendMessageButtonClick(_ sender: UIButton) {
        guard let inputMessage = messageTextField.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let user = user else { return }
        let rootNode = ref.child("Conversation").child("Messages")
        let value = ["content": inputMessage, "receiver": user.id, "sender": currentUser.uid]
        rootNode.childByAutoId().setValue(value)
        messageTextField.text = ""
    }
    
    @objc func handleKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomContainerView.constant = isKeyboardShowing ? keyboardFrame.height : 10
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { (complete) in
                if self.chatMessages.count != 0 {
                    let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                    self.chatMessageTableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    private func fetchChatOfUser(type: DataEventType, completion:@escaping ((Result<[Message],Error>) -> Void)) {
        guard let user = user else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        let conversationNode = ref.child("Conversation").child("Messages")
        conversationNode.observe(type, with: { (snapshot) in
            var tempMessages:[Message] = []
            for child in snapshot.children {
                let messSnapShot = child as! DataSnapshot
                let messageDict = messSnapShot.value as! [String:Any]
                let sender = messageDict["sender"] as! String
                let content = messageDict["content"] as! String
                let receiver = messageDict["receiver"] as! String
                // Lọc tin nhắn của current user với user khách sau đó thêm vào mảng tempMessages
                if (user.id == receiver && sender == currentUser.uid) || (receiver == currentUser.uid && sender == user.id)
                {
                    let message = Message(content: content, receiver: receiver, sender: sender)
                    tempMessages.append(message)
                }
            }
            // sau khi thêm thành công thì trả ra giá trị của tempMessages
            completion(.success(tempMessages))
        }, withCancel: nil)
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageTextField.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        guard let currentUser = Auth.auth().currentUser else { return UITableViewCell() }
        let message = chatMessages[indexPath.row]
        cell.setupDisplayForMessageTest(currentUserID: currentUser.uid, message: message)
        return cell
    }
}

