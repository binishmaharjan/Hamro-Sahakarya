//
//  MemberWithLoanCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

class MemberWithLoanCell: UITableViewCell {
    
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memberImageView.layer.cornerRadius = memberImageView.width / 2
        memberImageView.clipsToBounds = true
    }
    
    func bind(viewModel: MemberWithLoanViewModelProtocol) {
        memberImageView.loadImage(with: viewModel.imageUrl)
        memberNameLabel.text = viewModel.fullname
        loanAmountLabel.text = viewModel.loanAmount
    }
}
// MARK: ViewModel
protocol MemberWithLoanViewModelProtocol {
  var imageUrl: URL? { get }
  var fullname: String { get }
  var loanAmount: String { get }
}

struct MemberWithLoanCellViewModel: MemberWithLoanViewModelProtocol {
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
