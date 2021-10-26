//
//  ChatViewController.swift
//  ChatApp
//
//  Created by duytran on 10/26/21.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var chatMessageTableview: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    var chatMessages:[Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // outlets
        setupNavigationBar()
        setupSendMessageButton()
        setupChatTableView()
        // data
        createChatMessageData()
    }
    
    // MARK: - Set up outlets
    private func setupNavigationBar() {
        self.navigationItem.title = "Message"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemGreen
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        
    }
    
    // MARK: - Create datas
    private func createChatMessageData() {
        chatMessages = [Message(text: "Lunar New Year Festival often falls between late January and early February; it is among the most important holidays in Vietnam",
                                isIncoming: false),
                        Message(text: "Lunar New Year Festival often falls between late January and early February", isIncoming: true),
                        Message(text: "Officially, the festival includes the 1st, 2nd, and 3rd day in Lunar Calendar; however, Vietnamese people often spend nearly a month celebrating this special event.", isIncoming: false),
                        Message(text: "Tet Holiday gets its beginning marked with the first day in the Lunar Year; however, its preparation starts long before that. The 23rd day of the last Lunar month is East Day—a ritual worshiping Kitchen Gods (Tao Cong)", isIncoming: true),
                        Message(text: "Jade Emperor about all activities of households on earth. On New Year’s Eve, they return home to continue their duties as taking care of families.", isIncoming: false),
                        Message(text: "Most of my friends like to stay inside to play video games, read books or watch TV, but I have a good hobby of going outside and playing sports. I play many different sports in my free time; some of them are soccer, swimming, volleyball and basketball. Sometimes I also ride the bikes or do board skating with my cousin in the park.", isIncoming: true),
                        Message(text: "Lunar New Year Festival often falls between late January and early February", isIncoming: false),
                        Message(text: "In my opinion, doing sport is one of the rare hobbies that actually have good impacts on me. I am taller than most of my classmates thanks to swimming and basketball lessons that I take during summer time.", isIncoming: false),
                        Message(text: "Lunar New Year Festival often falls between late January and early February, Both of my physical and mental health become better after I play sports, so it can be considered as the best things to do in my free time. Sports are like a part of my life besides other activities, and I will continue to play sports till I am too weak for them.", isIncoming: true),
                        Message(text: "Both of my physical and mental health become better after I play sports, so it can be considered as the best things to do in my free time. Sports are like a part of my life besides other activities, and I will continue to play sports till I am too weak for them.", isIncoming: true),
                        Message(text: "Firstly, I love my ideal partner very much because she is enough clever to keep my heart cheerful and always helps me when I need her, especially in my studies.", isIncoming: false)]
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController : UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let message = chatMessages[indexPath.row]
        cell.setupDisplay(message: message)
        return cell
    }
}

