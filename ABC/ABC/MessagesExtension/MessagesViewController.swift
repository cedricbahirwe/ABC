//
//  MessagesViewController.swift
//  KeyPress
//
//  Created by Cedric Bahirwe on 11/12/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import AVFoundation


enum DataType: String, Codable {
    case message, image, song
}

struct Load<T: Codable>: Codable {
    var type: DataType
    var data: T
}

struct LoadType: Codable {
    var type: DataType
}
struct Message: Codable {
    var user: String
    var message: String
    var isMe = true
}

struct Image: Codable {
    var name: String?
    var image: Data
}

struct Song: Codable {
    var name: String
    var song: Data
    
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
    var imageCount = 1
    
    var audioPlayer: AVAudioPlayer?
    
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
    
    @IBAction func sendImage(_ sender: UIButton) {
        
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        self.textView.resignFirstResponder()
        let message = Message(user: UIDevice.current.name, message: textView.text)
        sendMessage(message)
        self.textView.text = ""
        
    }
    
//    func sendMessage(_ message: Message) {
//        if mcSession.connectedPeers.count > 0 {
//            do {
//                let data = try JSONEncoder().encode(message)
//                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
//                self.messages.append(message)
//            } catch let error as NSError {
//                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default))
//                present(ac, animated: true)
//            }
//        } else {
//            print("No peers found")
//        }
//    }
    
    func sendMessage(_ message: Message) {
        if mcSession.connectedPeers.count > 0 {
            do {
                
                let messageLoad = Load<Message>(type: .message, data: message)
                let data = try JSONEncoder().encode(messageLoad)
                let loadType = try JSONEncoder().encode(messageLoad.type)
//                data.append(loadType)
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
    
    func sendImage(_ image: UIImage) {
        
        if mcSession.connectedPeers.count > 0 {
            do {
                guard let imageData = image.jpegData(compressionQuality: 0) else { return }
                let imageLoad = Load<Image>(type: .image, data: Image(name: "image\(imageCount)", image: imageData))
                imageCount += 1
                let data = try JSONEncoder().encode(imageLoad)
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                imageCount -= 1
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        } else {
            print("No peers found")
        }
    }
    
    func sendSong(_ songURL: URL) {
        if mcSession.connectedPeers.count > 0 {
            do {
                let songData = try Data(contentsOf: songURL)
                let songLoad = Load<Song>(type: .song, data: Song(name: "song\(imageCount)", song: songData))
                imageCount += 1
                let data = try JSONEncoder().encode(songLoad)
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                imageCount -= 1
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        } else {
            print("No peers found")
        }
        
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? ""){
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        completion(filePath)
                        
                    } else {
                        print("file doesnt exist")
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    }
                } catch {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            }else{
                print("file doesnt exist")
            }
        }else{
            print("file doesnt exist")
        }
    }
    
    func playSavedSong(url: URL) {
        print("playing \(url)")
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.play()
            let percentage = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 1)
            DispatchQueue.main.async {
                // do what ever you want with that "percentage"
                print(percentage.description)
            }
            
        } catch let error {
            audioPlayer = nil
            print(error.localizedDescription)
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

extension MessagesViewController: AVAudioPlayerDelegate {
    
}
