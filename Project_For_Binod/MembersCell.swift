//
//  MembersCell.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/03.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class MembersCell: UITableViewCell {

    //MARK: IBOutlet and Variables
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var avaImage: UIImageView!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Customizing avaImage
        avaImage.layer.cornerRadius = 35
        avaImage.clipsToBounds = true
        
        //Changing the background color
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
