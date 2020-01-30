//
//  ProfileTopCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class ProfileTopCell: UITableViewCell {

  // MARK: IBOutlet
  @IBOutlet private weak var userImageView: UIImageView!
  @IBOutlet private weak var userNameLabel: UILabel!
  @IBOutlet private weak var statusLabel: UILabel!
  
  
  func bind(viewModel: ProfileTopCellViewModel) {
    userImageView.loadImage(with: viewModel.imageUrl)
    userNameLabel.text = viewModel.fullname
    statusLabel.text = viewModel.status.rawValue
  }
    
}

protocol ProfileTopCellViewModel {
  var imageUrl: URL? { get }
  var fullname: String { get }
  var status: Status { get }
}

struct DefaultProfileTopCellViewModel: ProfileTopCellViewModel {
  private let userProfile: UserProfile
  
  var imageUrl: URL? {
    let imageString = userProfile.iconUrl ?? ""
    return URL(string: imageString)
  }
  
  var fullname: String {
    return userProfile.username ?? ""
  }
  
  var status: Status {
    return userProfile.status ?? .member
  }
  
  init(userProfile: UserProfile) {
    self.userProfile = userProfile
  }
  
}
