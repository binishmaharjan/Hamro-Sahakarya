import AppUI
import Core
import Foundation
import PDFKit
import RxCocoa
import RxSwift

public protocol TermsAndConditionViewModelProtocol {
    var pdfDocument: Observable<PDFDocument> { get }
    var apiState: Driver<State> { get }
}

public struct TermsAndConditionViewModel: TermsAndConditionViewModelProtocol {
    private let userSessionRepository: UserSessionRepository
    
    @PropertyPublishSubject<PDFDocument>()
    public var pdfDocument: Observable<PDFDocument>
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    
    public init(userSessionRepository: UserSessionRepository) {
        self.userSessionRepository = userSessionRepository
        
        downloadTermsAndConditions()
    }
}

extension TermsAndConditionViewModel {
    public func downloadTermsAndConditions() {
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
