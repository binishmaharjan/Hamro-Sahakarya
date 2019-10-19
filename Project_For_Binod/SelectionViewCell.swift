//
//  SelectionViewCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/06/01.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import Kingfisher

class SelectionViewCell: UITableViewCell {

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  var user: HSMemeber? {
    didSet {
      self.userWasSet()
    }
  }
  
  override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
  
  private func setup() {
    userImageView.layer.cornerRadius = 45 / 2
  }
  
  private func userWasSet() {
    guard let user = self.user else { return }
    usernameLabel.text = user.username
    if let iconUrl = user.iconUrl, !iconUrl.isEmpty {
      userImageView.kf.setImage(with: URL(string: iconUrl))
    } else {
      userImageView.image = UIImage(named: "hamro_sahakarya")
    }
  }

}

extension SelectionViewCell: HasXib {}

