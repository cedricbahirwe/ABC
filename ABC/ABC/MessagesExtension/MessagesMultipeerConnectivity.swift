//
//  MessagesMultipeerConnectivity.swift
//  ABC
//
//  Created by Cedric Bahirwe on 11/18/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import Foundation
import MultipeerConnectivity

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
