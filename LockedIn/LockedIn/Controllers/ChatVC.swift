//
//  ChatVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/3/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatVC: MessagesViewController {
    
    // MARK: - Data
    private var messages = TestingData.messages
    var selfSender: Sender
    
    // MARK: - Life Cycle
    init(with sender: Sender) {
        self.selfSender = sender
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        setupNavBar()
        messagesCollectionView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        navigationItem.title = "Chat"
    }
    
    // MARK: - Networking Placeholder
    private func fetchMessagesFromAPI() {
        // TODO: Implement REST API call to fetch messages
    }
    
    private func sendMessageToAPI(message: Message) {
        // TODO: Implement REST API call to send a message
    }
}

extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var currentSender: any SenderType {
        return selfSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender.senderId == selfSender.senderId ? .palette.blue : .palette.offWhite
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let sender = message.sender as? Sender else {
            print("Error casting sender as type Sender")
            return
        }
        
        avatarView.image = sender.senderId == selfSender.senderId ? sender.avatar : selfSender.avatar
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // Create the new message
        let newMessage = Message(
            sender: selfSender,
            messageId: UUID().uuidString,
            sentDate: Date(),
            kind: .text(text)
        )
        
        // Add the message to the local array
        messages.append(newMessage)
        
        // Reload the messages view
        messagesCollectionView.reloadData()
        
        // Scroll to the most recent message
        messagesCollectionView.scrollToLastItem(animated: true)
        
        // Clear the input bar
        inputBar.inputTextView.text = ""
    }
}
