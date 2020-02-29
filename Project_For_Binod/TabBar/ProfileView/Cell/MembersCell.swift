//
//  MembersViewCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class MembersCell: UITableViewCell {
  
  // MARK: IBOutlet
  @IBOutlet private weak var memberImageView: UIImageView!
  @IBOutlet private weak var memberNameLabel: UILabel!
  @IBOutlet private weak var memberStatusLabel: UILabel!
  
  // MARK: LifeCycle
  override func awakeFromNib() {
    super.awakeFromNib()
    memberImageView.layer.cornerRadius = 25
    memberImageView.clipsToBounds = true
  }
  
  func bind(userProfile: UserProfile) {
    memberNameLabel.text = userProfile.username
    memberStatusLabel.text = userProfile.status.rawValue
    memberImageView.loadImage(with: URL(string: userProfile.iconUrl!))
  }
}

protocol MembersCellViewModel {
  
}
