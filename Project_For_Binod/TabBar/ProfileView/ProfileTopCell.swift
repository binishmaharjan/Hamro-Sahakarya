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
  private let userSession: UserSession
  
  var imageUrl: URL? {
    let imageString = userSession.profile.iconUrl ?? ""
    return URL(string: imageString)
  }
  
  var fullname: String {
    return userSession.profile.username ?? ""
  }
  
  var status: Status {
    return userSession.profile.status ?? .member
  }
  
  init(userSession: UserSession) {
    self.userSession = userSession
  }
  
}
