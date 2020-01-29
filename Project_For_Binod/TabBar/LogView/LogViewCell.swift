//
//  LogViewCell.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/20.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class LogViewCell: UITableViewCell {

  // MARK: IBOutlet
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  
  // MARK: Properties
  private var viewModel: LogCellViewModel!
  
  // MARK: Methods
  func bind(viewModel: LogCellViewModel) {
    self.viewModel = viewModel
    dateLabel.text = viewModel.dateCreated
    titleLabel.text = viewModel.title
    descriptionLabel.text = viewModel.description
  }
}
