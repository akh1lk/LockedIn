//
//  ChatVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/3/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView

// TODO: Improve how the chat VC looks please!
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
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 2, left: 5, bottom: 0, right: 5)
        }
        
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

        // Show avatar only for incoming messages, hide for consecutive messages from the same sender
        let shouldHideAvatar: Bool = {
            // Only hide avatar if the next message is from the same sender (for consecutive messages)
            if indexPath.section < messages.count - 1 {
                let nextMessage = messages[indexPath.section + 1]
                return nextMessage.sender.senderId == sender.senderId
            }
            return false // Don't hide the avatar for the last message in the sequence
        }()

        avatarView.isHidden = shouldHideAvatar
        if !shouldHideAvatar {
            avatarView.image = sender.avatar
        }
    }

    
    // MARK: - Time Gap Logic (5 minutes & every hour)
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard indexPath.section > 0, let currentMessage = message as? Message else {
            return 0 // No need for space if there's no timestamp
        }
        
        let previousMessage = messages[indexPath.section - 1]
        let calendar = Calendar.current
        let timeDifference = calendar.dateComponents([.minute], from: previousMessage.sentDate, to: currentMessage.sentDate).minute ?? 0
        let minutesPastHour = calendar.component(.minute, from: currentMessage.sentDate)
        
        let shouldShowTimestamp = shouldDisplayTimestamp(for: currentMessage, at: indexPath)
        return shouldShowTimestamp ? 20 : 0
    }
    
    func cellBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        let currentMessage = messages[indexPath.section]
        let isLastMessageFromSender = indexPath.section == messages.count - 1 || currentMessage.sender.senderId != messages[indexPath.section + 1].sender.senderId
        
        return isLastMessageFromSender ? 16 : 0
    }
    
    // MARK: - Top Label Text
    func cellTopLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        guard let message = message as? Message else { return nil }
        
        if indexPath.section == 0 || shouldDisplayTimestamp(for: message, at: indexPath) {
            return createTimestampAttributedString(from: message.sentDate)
        }
        return nil
    }
    
    // MARK: - Bottom Label Text
    func cellBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let currentMessage = messages[indexPath.section]
        let isLastMessageFromSender = indexPath.section == messages.count - 1 || currentMessage.sender.senderId != messages[indexPath.section + 1].sender.senderId
        
        return isLastMessageFromSender ? NSAttributedString(
            string: currentMessage.sender.displayName,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.5, alpha: 1)
            ]
        ) : nil
    }
    
    // MARK: - Helper: Display Timestamp Decision
    private func shouldDisplayTimestamp(for message: Message, at indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0 else { return true }
        
        let previousMessage = messages[indexPath.section - 1]
        let calendar = Calendar.current
        
        // Calculate time differences
        let timeDifference = calendar.dateComponents([.minute], from: previousMessage.sentDate, to: message.sentDate).minute ?? 0
        let hourDifference = calendar.dateComponents([.hour], from: previousMessage.sentDate, to: message.sentDate).hour ?? 0
        
        // Check for a perfect hour mark
        let isOnTheHour = calendar.component(.minute, from: message.sentDate) == 0
        
        // Check if message is from a different sender
        let isDifferentSender = message.sender.senderId != previousMessage.sender.senderId
        
        // Show timestamp if:
        // 1. Time difference is 30+ minutes
        // 2. Other person responded after 5 minutes
        // 3. Continuous conversation over 30 minutes and it's exactly on the hour
        if timeDifference >= 30 ||
            (isDifferentSender && timeDifference >= 5) ||
            (hourDifference >= 0 && isOnTheHour) {
            return true
        }
        
        return false
    }
    
    // MARK: - Helper: Create Timestamp String
    private func createTimestampAttributedString(from date: Date) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        
        return NSAttributedString(
            string: dateString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 11, weight: .regular),
                .foregroundColor: UIColor.gray
            ]
        )
    }
}

    // MARK: - Message Sending Handling
    extension ChatVC: InputBarAccessoryViewDelegate {
        
        func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return
            }
            
            let newMessage = Message(
                sender: selfSender,
                messageId: UUID().uuidString,
                sentDate: Date(),
                kind: .text(text)
            )
            
            messages.append(newMessage)
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem(animated: true)
            inputBar.inputTextView.text = ""
        }
    }
