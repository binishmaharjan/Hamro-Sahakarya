//
//  LogCell.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/06.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {

    //MARK: IBOutlet and Variables
    @IBOutlet var avaImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var logLabel: UILabel!
    @IBOutlet var logsAreaView: UIView!
    
    //MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customizing the avaImageView
        avaImageView.layer.cornerRadius = 33
        avaImageView.clipsToBounds = true
        
        //Customising log area avaImageView
        logsAreaView.layer.cornerRadius = 5
        logsAreaView.layer.borderWidth = 1
        logsAreaView.layer.borderColor = UIColor(red: 143/255, green: 101/255, blue: 147/255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
