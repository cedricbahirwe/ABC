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
            
            
//            do {
//                print(data.count, "the number")
//                let formattedData = Data([data[1]])
//                let mainData = Data([data[0]])
//                let receivedData = try JSONDecoder().decode(LoadType.self, from: Data(formattedData))
//                switch receivedData.type {
//                case .message:
//                    do {
//                        var message = try  JSONDecoder().decode(Load<Message>.self, from: mainData)
//                        print(data.count)
//                        message.data.isMe.toggle()
//                        self.messages.append(message.data)
//                    } catch {
//                        print("Unable to decode the message")
//                    }
//                case .image:
//                    do {
//                        let image = try  JSONDecoder().decode(Load<Image>.self, from: mainData)
//                        print(image.data.name ?? "No image name")
//                    } catch {
//                        print("Unable to decode the image")
//                    }
//                case .song:
//                    do {
//                        let song = try  JSONDecoder().decode(Load<Song>.self, from: mainData)
//                        print(song.data.name)
//                    } catch {
//                        print("Unable to decode the song")
//                    }
//                }
//            } catch {
//                print("Unable to decode the data")
//            }
            
            
            
            
            
            do {
                var message = try  JSONDecoder().decode(Load<Message>.self, from: data)
                print(data.count)
                message.data.isMe.toggle()
                self.messages.append(message.data)
            } catch {
                print("Unable to decode the message")
                do {
                    let image = try  JSONDecoder().decode(Load<Image>.self, from: data)
                    print(image.data.name ?? "No image name")
                    self.sentImageView.image = UIImage(data: image.data.image)
                } catch {
                    print("Unable to decode the image")
                    do {
                        let song = try  JSONDecoder().decode(Load<Song>.self, from: data)
                        print(song.data.name)
                    } catch {
                        print("Unable to decode the song")
                    }
                }
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
