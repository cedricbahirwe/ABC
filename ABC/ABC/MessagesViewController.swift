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
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.lightGray
        
        self.textView.layer.cornerRadius = 20
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.lightGray.cgColor
        self.textView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        // Do any additional setup after loading the view.
        self.containerView.layer.cornerRadius = 30
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.tableView.register(UINib(nibName: "ClientTableViewCell", bundle: nil), forCellReuseIdentifier: "ClientTableViewCell")
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        bottomConstraint.constant = keyboardSize.height - bottomPadding
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        bottomConstraint.constant = 0
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
extension MessagesViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.numberOfLines() > 1 {
            if textView.numberOfLines() < 5 {
            UIView.animate(withDuration: 0.26) {
                self.textViewContainerheight.constant = CGFloat(40 * textView.numberOfLines())
            }
            }
        } else {
            UIView.animate(withDuration: 0.26) {
                self.textViewContainerheight.constant = 50.0
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Hello")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
    }
    /*
     func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
     return
     }
     
     func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
     
     }
     */
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messages.count
        //            self.messages.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80.0
//    }
//    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let message = self.messages[indexPath.row]
        if message.isMe  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.userName.text = message.user
            cell.message.text = message.message
            //            if #available(iOS 13.0, *) {
            //                cell.containerView.backgroundColor = UIColor.systemBackground
            //            } else {
            //                cell.containerView.backgroundColor = UIColor.white
            //            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClientTableViewCell", for: indexPath) as! ClientTableViewCell
            cell.userName.text = message.user
            cell.message.text = message.message
            
            //            cell.containerView.backgroundColor = UIColor.gray
            
            return cell
        }
        
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.messages.remove(at: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    
    }
    
}

extension MessagesViewController : MCSessionDelegate, MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.title = "Messages"
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 4, options: [], animations: {
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
                    
                }, completion: { dismissed in
                    
                })
                //                self.performSegue(withIdentifier: "segueToTable", sender: self)
                //
            }
            
        //            self.joiningDelegate?.didFinishJoining(mcSession)
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            mcSession.disconnect()
            
        @unknown default:
            print("Unknow Status")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {[unowned self] in
            do {
                var message = try  JSONDecoder().decode(Message.self, from: data)
                message.isMe.toggle()
                self.messages.append(message)
            } catch {
                print("Unable to decode the message")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}



extension MessagesViewController {
    @IBAction func sendMessage(_ sender: UIButton) {
        self.textView.resignFirstResponder()
        let message = Message(user: UIDevice.current.name, message: textView.text)
        sendMessage(message)
        self.textView.text = ""
        
    }
    
    func sendMessage(_ message: Message) {
        if mcSession.connectedPeers.count > 0 {
            do {
                let data = try JSONEncoder().encode(message)
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                self.messages.append(message)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        } else {
            print("No peers found")
        }
    }
    
    
    @IBAction func joinSession(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Do you want to join a session", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let start = UIAlertAction(title: "Join", style: .default, handler: joinSession(action:))
        
        alert.addAction(cancel)
        alert.addAction(start)
        alert.preferredAction = start
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func startSession(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to start a new session", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let start = UIAlertAction(title: "Start", style: .default, handler: startHosting(action:))
        
        alert.addAction(cancel)
        alert.addAction(start)
        alert.preferredAction = start
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "cedric-session", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "cedric-session", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
}


extension UITextView {
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(
                forGlyphAt: index, effectiveRange: &lineRange
            )
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
