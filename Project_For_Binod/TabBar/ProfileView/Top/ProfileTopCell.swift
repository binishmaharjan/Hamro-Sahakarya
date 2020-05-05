//
//  ProfileTopCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class ProfileTopCell: UITableViewCell {

  // MARK: IBOutlet
  @IBOutlet private weak var userImageView: UIImageView!
  @IBOutlet private weak var userNameLabel: UILabel!
  @IBOutlet private weak var statusLabel: UILabel!
    
    private let disposeBag = DisposeBag()
  
  // MARK: Methods
  func bind(viewModel: ProfileTopCellViewModel) {
    //Output
    viewModel.fullname
        .drive(userNameLabel.rx.text)
        .disposed(by: disposeBag)
    
    viewModel.status
        .drive(statusLabel.rx.text)
        .disposed(by: disposeBag)
    
    viewModel.imageUrl.drive(onNext: { [weak self] (url) in
        self?.userImageView.loadImage(with: url)
    }).disposed(by: disposeBag)
  }
    
}
