//
//  TermsAndConditionViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/03.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import PDFKit
import RxSwift
import RxCocoa

protocol TermsAndConditionViewModelProtocol {
    
    var pdfDocument: Observable<PDFDocument> { get }
    var apiState: Driver<State> { get }
}

struct TermsAndConditionViewModel: TermsAndConditionViewModelProtocol {
    
    private let userSessionRepository: UserSessionRepository
    
    @PropertyPublishSubject<PDFDocument>()
    var pdfDocument: Observable<PDFDocument>
    @PropertyBehaviourRelay<State>(value: .idle)
    var apiState: Driver<State>
    
    init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
        
        downloadTermsAndConditions()
    }
}

extension TermsAndConditionViewModel {
    
    func downloadTermsAndConditions() {
        indicateLoading()
        
        userSessionRepository
            .downloadTermsAndCondition()
            .done(indicateDownloadSuccessful)
            .catch(indicateError)
    }
    
    private func indicateDownloadSuccessful(pdfData: Data) {
        _pdfDocument.onNext(PDFDocument(data: pdfData)!)
        _apiState.accept(.completed)
    }
    
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
