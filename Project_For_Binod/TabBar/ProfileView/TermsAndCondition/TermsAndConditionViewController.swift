//
//  TermsAndConditionViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/03.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class TermsAndConditionViewController: UIViewController {
    
    // MARK: Properties
    private var viewModel: TermsAndConditionViewModelProtocol!
}

// MARK: Storyboard Instantiable
extension TermsAndConditionViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: TermsAndConditionViewModelProtocol) -> TermsAndConditionViewController {
        let viewController = TermsAndConditionViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}
