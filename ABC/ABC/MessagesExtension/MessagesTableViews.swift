//
//  MessagesTableViews.swift
//  ABC
//
//  Created by Cedric Bahirwe on 11/18/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import Foundation
import UIKit

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
