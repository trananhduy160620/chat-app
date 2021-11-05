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
    var newTextMessage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupNavigationBar()
        setupMessageTextField()
        setupSendMessageButton()
        setupChatTableView()
        setupKeyboardObserver()
        fetchChat()
    }
    
    // MARK: - Set up outlets
    private func setupNavigationBar() {
        if let user = user {
            self.navigationItem.title = user.displayName
        }
    }
    
    private func setupMessageTextField() {
        let attributted = NSAttributedString(string: "Input message here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        messageTextField.attributedPlaceholder = attributted
    }
    
    private func setupSendMessageButton() {
        let sendImage = UIImage(systemName: "paperplane.fill")
        sendMessageButton.setImage(sendImage?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
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
        guard let content = messageTextField.text else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let user = user else { return }
        if content != "" {
            let message = Message(content: content, receiverID: user.id, senderID: currentUser.uid)
            FirebaseChatManager.shared.addChat(message: message) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomContainerView.constant = isKeyboardShowing ? keyboardFrame.height : 10
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseInOut) {
                self.view.layoutIfNeeded()
            } completion: { (complete) in
                self.tableViewScrollRowAtBottom()
            }
        }
    }
    
    private func fetchChat() {
        guard let user = user else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        FirebaseChatManager.shared.fetchChat(currentUserID: currentUser.uid, with: user.id) { (result) in
            switch result {
            case .success(let listMessage):
                DispatchQueue.main.async {
                    self.chatMessages = listMessage
                    self.chatMessageTableview.reloadData()
                    self.tableViewScrollRowAtBottom()
                }
            case .failure(_):
                print("Fetch Chat error")
            }
        }
    }
    
    private func tableViewScrollRowAtBottom() {
        if chatMessages.count != 0 {
            let indexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
            self.chatMessageTableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

