import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public protocol UpdateNoticeStateProtocol {
    var notice: String { get }
}

extension UpdateNoticeStateProtocol {
    public var isUpdateNoticeButtonEnabled: Bool {
        return notice.count > 5
    }
}

public protocol UpdateNoticeViewModelProtocol {
    var apiState: Driver<State> { get }
    var noticeInput: BehaviorRelay<String?> { get }
    var isUpdateNoticeButtonEnabled: Observable<Bool> { get }
    func updateNotice()
}

public struct UpdateNoticeViewModel: UpdateNoticeViewModelProtocol {
    public struct UIState: UpdateNoticeStateProtocol {
        public var notice: String
    }
    
    private let userSession: UserSession
    private let userSessionRepository: UserSessionRepository
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var apiState: Driver<State>
    
    public var noticeInput = BehaviorRelay<String?>(value: "")
    public var isUpdateNoticeButtonEnabled: Observable<Bool>
    
    public init(
        userSessionRepository: UserSessionRepository,
        userSession: UserSession
    ) {
        self.userSessionRepository = userSessionRepository
        self.userSession = userSession
        
        let state = noticeInput.asObservable()
            .map { UIState(notice: $0 ?? "") }
        isUpdateNoticeButtonEnabled = state.map { $0 .isUpdateNoticeButtonEnabled }
    }
}

// MARK: API
extension UpdateNoticeViewModel {
    public func updateNotice() {
        indicateLoading()
        
        let userProfile = userSession.profile.value
        let notice = noticeInput.value ?? ""
        
        userSessionRepository
            .updateNotice(userProfile: userProfile, notice: notice)
            .done { self.indicateUpdateSuccessful() }
            .catch(indicateError(error:))
    }
    
    private func indicateLoading() {
        _apiState.accept(.loading)
    }
    
    private func indicateUpdateSuccessful() {
        _apiState.accept(.completed)
    }
    
    private func indicateError(error: Error) {
        _apiState.accept(.error(error))
    }
}
