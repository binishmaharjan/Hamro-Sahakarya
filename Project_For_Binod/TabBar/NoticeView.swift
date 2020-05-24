//
//  NoticeView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/24.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class NoticeView: UIView {
    
    //MARK: IBOultet
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateCreatedLabel: UILabel!
    @IBOutlet private weak var adminLabel: UILabel!
    
    // MARK: Properties
    private var viewModel: NoticeViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    
    func bind() {
        //Output
        viewModel.message
            .asDriver()
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.admin
            .asDriver()
            .drive(adminLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateCreated
            .asDriver()
            .drive(dateCreatedLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: Xib Instantiable
extension NoticeView: HasXib {
    
    static func makeInstance(viewModel: NoticeViewModelProtocol) -> NoticeView {
        let noticeView = NoticeView.loadXib()
        noticeView.viewModel = viewModel
        return noticeView
    }
}
