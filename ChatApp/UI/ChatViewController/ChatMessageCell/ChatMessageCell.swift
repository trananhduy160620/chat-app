//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by duytran on 10/26/21.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageContainerView.layer.cornerRadius = 12
        messageContainerView.layer.masksToBounds = true
    }
    
    func setupDisplayForMessageTest(currentUserID:String, message: Message) {
        messageContainerView.backgroundColor = currentUserID == message.sender ? .systemGreen : .white
        messageLabel.backgroundColor = currentUserID == message.sender ? .systemGreen : .white
        messageLabel.textColor = currentUserID == message.sender ? .white : .black
        messageLabel.text = message.content
        leadingConstraint.isActive = false
        if currentUserID == message.sender {
            leadingConstraint = messageContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        } else {
            leadingConstraint = messageContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        }
        leadingConstraint.isActive = true
        setNeedsLayout()
    }
}
