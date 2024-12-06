//
//  ChatVC.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 12/3/24.
//

import UIKit
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

class ChatVC: MessagesViewController {
    
    // MARK: - UI Components
    let chatHeaderView: ChatHeaderView
    
    // MARK: - Data
    private var messages: [Message] = []
    var selfSender: Sender
    let connectionId: String
    private var messagesListener: ListenerRegistration?
    
    // MARK: - Life Cycle
    init(with sender: Sender, connectionId: String) {
        self.selfSender = sender
        self.connectionId = connectionId
        
        chatHeaderView = ChatHeaderView(sender: sender)
        super.init(nibName: nil, bundle: nil)
        
        chatHeaderView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        super.viewDidLoad()
        
        // Set data sources and delegates
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        setupUI()
        messagesCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchAllMessages()
//        setupMessagesListener()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Chats"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.sectionInset = UIEdgeInsets(top: 1.5, left: 3, bottom: 1.5, right: 3)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        
        messagesCollectionView.contentInset.top = 80
        
        self.view.addSubview(chatHeaderView)
        chatHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chatHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor),
            chatHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatHeaderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatHeaderView.heightAnchor.constraint(equalToConstant: 130),
        ])
    }
    
    // MARK: - Networking
    private func fetchAllMessages() {
        FirestoreHandler.shared.returnAllMessages(for: connectionId) { [weak self] result in
            switch result {
            case .success(let messages):
                // Sort messages by sentDate in ascending order
                self?.messages = messages.sorted { $0.sentDate < $1.sentDate }
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadData()
                    
                    // Scroll to bottom:
                    self?.messagesCollectionView.scrollToLastItem()
                }
            case .failure(let error):
                print("Error fetching messages: \(error)")
            }
        }
    }
    
    private func setupMessagesListener() {
        let db = Firestore.firestore()
        
        let storageRef = db
            .collection("chats")
            .document(connectionId)
            .collection("messages")
        
        messagesListener = storageRef.addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                print("Error listening for messages: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No messages found.")
                return
            }
            
            let newMessages = documents.compactMap { document -> Message? in
                return Utils.createMessage(from: document.data())
            }
            
            // Update messages with new messages and reload collection view
            self?.messages = newMessages.sorted { $0.sentDate < $1.sentDate }
            DispatchQueue.main.async {
                self?.messagesCollectionView.reloadData()
                // Scroll to the bottom
                // self?.messagesCollectionView.scrollToBottom(animated: true)
                self?.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
    deinit {
        messagesListener?.remove()
    }
}

// MARK: - MessageKit Delegates
extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var currentSender: SenderType {
        return selfSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender.senderId == selfSender.senderId ? .palette.purple : .palette.offWhite
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true // Always hide avatar
    }
    
    // MARK: - Time Display
    // it shows the date & time if it is the first message sent in the day.
    // it shows time if the message was sent more than 30 minutes from the previous message.
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let isFirstMessageOfDay = isFirstMessageOfDay(for: message as! Message, at: indexPath)
        let shouldDisplayTime = shouldDisplayTimestamp(for: message as! Message, at: indexPath)
        
        guard isFirstMessageOfDay || shouldDisplayTime else { return nil }
        
        let dateFormatter = DateFormatter()
        var timestampText = ""
        
        if isFirstMessageOfDay {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            timestampText = dateFormatter.string(from: message.sentDate)
        } else if shouldDisplayTime {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            timestampText = dateFormatter.string(from: message.sentDate)
        }
        
        return NSAttributedString(string: timestampText, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.lightGray
        ])
    }

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFirstMessageOfDay(for: message as! Message, at: indexPath) || shouldDisplayTimestamp(for: message as! Message, at: indexPath) ? 20 : 0
    }

    private func shouldDisplayTimestamp(for message: Message, at indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0 else { return true }
        let previousMessage = messages[indexPath.section - 1]
        let timeDifference = Calendar.current.dateComponents([.minute], from: previousMessage.sentDate, to: message.sentDate).minute ?? 0
        return timeDifference >= 30
    }

    private func isFirstMessageOfDay(for message: Message, at indexPath: IndexPath) -> Bool {
        guard indexPath.section > 0 else { return true }
        let previousMessage = messages[indexPath.section - 1]
        
        let currentMessageDate = Calendar.current.startOfDay(for: message.sentDate)
        let previousMessageDate = Calendar.current.startOfDay(for: previousMessage.sentDate)
        
        return currentMessageDate > previousMessageDate
    }


    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        if message.sender.senderId == selfSender.senderId {
            return .bubbleTail(.bottomRight, .curved)
        } else {
            return .bubbleTail(.bottomLeft, .curved)
        }
    }
}

extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
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

// MARK: - Chat Header Delegate
extension ChatVC: ChatHeaderDelegate {
    func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
}
