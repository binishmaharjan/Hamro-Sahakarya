//
//  MemberWithLoanCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

class MemberWithLoanCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
// MARK: ViewModel
protocol MemberWithLoanViewModelProtocol {
  var imageUrl: URL? { get }
  var fullname: String { get }
  var loanAmount: String { get }
}

struct MemberWithLoanViewModel: MemberWithLoanViewModelProtocol {
  private let profile: UserProfile
   
   var imageUrl: URL? {
     let imageString = profile.iconUrl ?? ""
     return URL(string: imageString)
   }
   
   var fullname: String {
     return profile.username
   }
   
   var loanAmount: String {
     return "Loan Taken: \(profile.loanTaken)"
   }
   
   init(profile: UserProfile) {
     self.profile = profile
   }
}
