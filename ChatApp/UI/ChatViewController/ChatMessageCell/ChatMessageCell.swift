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
    
    func setupDisplay(message: Message) {
        messageContainerView.backgroundColor = message.isIncoming ? .white : .systemGreen
        messageLabel.backgroundColor = message.isIncoming ? .white : .systemGreen
        messageLabel.textColor = message.isIncoming ? .black : .white
        messageLabel.text = message.text
        
        leadingConstraint.isActive = false
        if message.isIncoming {
            leadingConstraint = messageContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        } else {
            leadingConstraint = messageContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        }
        leadingConstraint.isActive = true
        setNeedsLayout()
    }
}
