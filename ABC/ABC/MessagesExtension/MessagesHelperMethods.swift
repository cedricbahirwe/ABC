//
//  MessagesHelperMethods.swift
//  ABC
//
//  Created by Cedric Bahirwe on 11/18/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity


extension MessagesViewController {
    
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
