//
//  LogViewCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class LogViewCell: UITableViewCell {

  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
