//
//  UpdateNoticeViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2021/10/04.
//  Copyright © 2021 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class UpdateNoticeViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var noticeTextView: UITextView!
    @IBOutlet weak var updateNoticeButton: MainOrangeButton!
    
    // MARK: Properties
    private var viewModel: UpdateNoticeViewModelProtocol!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        bindApiState()
        bindUIState()
    }
    
    @IBAction func updateNoticeButtonPressed(_ sender: Any) {
    }
}

// MARK: Setup
extension UpdateNoticeViewController {
    
    private func setup() {
        title = "Update Notice"
    }
}

// MARK: Storyboard Instantiable
extension UpdateNoticeViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: UpdateNoticeViewModelProtocol) -> UpdateNoticeViewController {
        let viewController = UpdateNoticeViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Bindable
extension UpdateNoticeViewController {
    
    private func bindApiState() {
        viewModel.apiState.driveNext { state in
            switch state {
            case .completed:
                GUIManager.shared.stopAnimation()
            case .error(let error):
                let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                GUIManager.shared.stopAnimation()
            case .loading:
                GUIManager.shared.startAnimation()
            case .idle:
                break
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func bindUIState() {
        // Input
        noticeTextView.rx.text
            .asDriver()
            .drive(viewModel.noticeInput)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .isUpdateNoticeButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(updateNoticeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}


// MARK: Get Associated View
extension UpdateNoticeViewController: ViewControllerWithAssociatedView {
    func getAssociateView() -> ProfileMainView {
        return .updateNotice
    }
    
}
