//
//  AddOrDeductAmountViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/17.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

final class AddOrDeductAmountViewController: UIViewController {
    
    //MARK: Properties
    private var viewModel: AddOrDeductAmountViewModelProtocol!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: Storyboard Instantiable
extension AddOrDeductAmountViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: AddOrDeductAmountViewModelProtocol) -> AddOrDeductAmountViewController {
        let viewController = AddOrDeductAmountViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

//MARK: Associate View
extension AddOrDeductAmountViewController: ViewControllerWithAssociatedView {
    
    func getAssociateView() -> ProfileMainView {
        return .addOrDeductAmount
    }
}
