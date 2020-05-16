//
//  MemberGraphLegendView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/16.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class MemberGraphLegendView: UIView {
    
    @IBOutlet private weak var memberColorView: UIView!
    @IBOutlet private weak var memberNameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var loanLabel: UILabel!
    @IBOutlet private weak var legendHighligherView: UIView!
    
    private var userProfile: UserProfile!
    private var isSelf: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        populateView()
        highLightIfUserIsSelf()
    }
    
    private func populateView() {
        memberColorView.backgroundColor = UIColor(hex: userProfile.colorHex)
        memberNameLabel.text = userProfile.username
        balanceLabel.text = userProfile.balance.currency
        loanLabel.text = userProfile.loanTaken.currency
    }
    
    private func highLightIfUserIsSelf() {
        guard isSelf else { return }
        
        memberColorView.backgroundColor = .white
        memberNameLabel.textColor = .white
        balanceLabel.textColor = .white
        loanLabel.textColor = .white
        legendHighligherView.backgroundColor = UIColor(hex: userProfile.colorHex)
    }
}

// MARK: Xib Instantiable
extension MemberGraphLegendView: HasXib {
    static func makeInstance(userProfile: UserProfile, isSelf: Bool) -> MemberGraphLegendView {
        let legendView = MemberGraphLegendView.loadXib()
        legendView.userProfile = userProfile
        legendView.isSelf = isSelf
        legendView.setup()
        return legendView
    }
}
