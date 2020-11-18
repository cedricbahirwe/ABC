//
//  MainViewController.swift
//  KeyPress
//
//  Created by Cedric Bahirwe on 11/12/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MainViewController: UIViewController {
    
    @IBOutlet weak var connectionStatus: UILabel!
    
    var joiningDelegate: FinishConnectionDelegate?
    
    var image: UIImage = #imageLiteral(resourceName: "moi")
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let message = Message(user: UIDevice.current.name, message: "Hello my friend")
        sendMessage(message)
    }
    
    func sendMessage(_ message: Message) {
        if mcSession.connectedPeers.count > 0 {
            do {
                let data = try JSONEncoder().encode(message)
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        } else {
            print("No peers found")
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "segueToTable" {
                if let _ = segue.destination as? MessagesViewController {
                    
               }
            }
        }
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
    
    @IBAction func joinSession(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Do you want to join a session", message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let start = UIAlertAction(title: "Join", style: .default, handler: joinSession(action:))
        
        alert.addAction(cancel)
        alert.addAction(start)
        alert.preferredAction = start
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func sendImage(img: UIImage) {
        if mcSession.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    
    func startHosting(action: UIAlertAction!) {
        self.connectionStatus.text = "Starting..."
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "cedric-session", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "cedric-session", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
}

extension MainViewController : MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segueToTable", sender: self)
                

            }
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.connectionStatus.text = "Connnecting..."
            }
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.connectionStatus.text = "Not Connnecting"
            }
        @unknown default:
            print("Unknow Status")
            DispatchQueue.main.async {
                self.connectionStatus.text = "No Status yet"
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [unowned self] in
                // do something with the image
                self.image = image
            }
        } else {
            do {
                let message = try  JSONDecoder().decode(Message.self, from: data)
                print("The m", message.message)
                self.joiningDelegate?.didReceiveData(message)
            } catch {
                print("Unable to decode the message")
            }

        }
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}





protocol FinishConnectionDelegate {
    func didFinishJoining(_ session: MCSession)
    
    
    func didReceiveData(_ messafe: Message)
}
