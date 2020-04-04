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
    memberImageView.layer.cornerRadius = memberImageView.width / 2
    memberImageView.clipsToBounds = true
  }
  
  // MARK: Methods
  func bind(viewModel: MemberCellViewModel) {
    memberNameLabel.text = viewModel.fullname
    memberStatusLabel.text = viewModel.status
    memberImageView.loadImage(with: viewModel.imageUrl)
  }
  
  func makeAllCell() {
    memberNameLabel.text = "All"
    memberStatusLabel.text = "Status: -"
    memberImageView.image = UIImage(named: "hamro_sahakarya")
  }
}

// MARK: ViewModel
protocol MemberCellViewModel {
  var imageUrl: URL? { get }
  var fullname: String { get }
  var status: String { get }
}

struct DefaultMemberCellViewModel: MemberCellViewModel {
  private let profile: UserProfile
   
   var imageUrl: URL? {
     let imageString = profile.iconUrl ?? ""
     return URL(string: imageString)
   }
   
   var fullname: String {
     return profile.username
   }
   
   var status: String {
     return "Status: \(profile.status .rawValue)"
   }
   
   init(profile: UserProfile) {
     self.profile = profile
   }
}
