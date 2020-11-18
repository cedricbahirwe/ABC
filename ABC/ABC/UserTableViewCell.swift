//
//  UserTableViewCell.swift
//  KeyPress
//
//  Created by Cedric Bahirwe on 11/12/20.
//  Copyright © 2020 Cedric Bahirwe. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
       @IBOutlet weak var profileImageView: UIImageView!
       @IBOutlet weak var userName: UILabel!
       @IBOutlet weak var message: UILabel!
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
        containerView.layer.cornerRadius = 25
          profileImageView.layer.cornerRadius = profileImageView.frame.width/2

       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }

}
