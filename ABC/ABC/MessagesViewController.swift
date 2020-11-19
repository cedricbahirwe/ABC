//
//  MessagesViewController.swift
//  KeyPress
//
//  Created by Cedric Bahirwe on 11/12/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct Message: Codable {
    var user: String
    var message: String
    var isMe = true
}



extension MessagesViewController: FinishConnectionDelegate {
    func didFinishJoining(_ session: MCSession) { }
    
    func didReceiveData(_ messafe: Message) { }
}

class MessagesViewController: UIViewController {
    
    var messages: [Message] = [] {
        didSet { DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
            
            } }
    }
    
    
    @IBOutlet weak var textViewContainerheight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.alpha = 1
        setupTableView()
        setupLayouts()
        setupMultipeering()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupMultipeering() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
    }
    
    func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.lightGray
        self.textView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.tableView.register(UINib(nibName: "ClientTableViewCell", bundle: nil), forCellReuseIdentifier: "ClientTableViewCell")
    }
    
    func setupLayouts() {
        self.textView.layer.cornerRadius = 20
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.containerView.layer.cornerRadius = 30
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
