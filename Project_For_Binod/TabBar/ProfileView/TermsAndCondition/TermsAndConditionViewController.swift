//
//  TermsAndConditionViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/03.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import PDFKit

final class TermsAndConditionViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var pdfView: PDFView!
    
    // MARK: Properties
    private var viewModel: TermsAndConditionViewModelProtocol!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        title = "Terms And Conditions"
        
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.document = viewModel.pdfDocument
    }
}

// MARK: Storyboard Instantiable
extension TermsAndConditionViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: TermsAndConditionViewModelProtocol) -> TermsAndConditionViewController {
        let viewController = TermsAndConditionViewController.loadFromStoryboard()
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Associated View
extension TermsAndConditionViewController: ViewControllerWithAssociatedView {
    func getAssociateView() -> ProfileMainView {
        return .termsAndCondition
    }

}
