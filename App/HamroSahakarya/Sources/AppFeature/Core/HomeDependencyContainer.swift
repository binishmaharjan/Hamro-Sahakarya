import AppUI
import Core
import Foundation
import RxSwift
import HomeFeature

internal final class HomeDependencyContainer {
    //MARK: Properties
    private let sharedUserSessionRepository: UserSessionRepository
    private let sharedMainViewModel: MainViewModel
    private let userSession: UserSession
    
    private let homeMainViewModel: HomeMainViewModel
    
    // MARK: Init
    init(
        dependencyContainer: SignedInDependencyContainer,
        userSession: UserSession
    ) {
        func makeHomeMainViewModel() -> HomeMainViewModel {
            return HomeMainViewModel()
        }
        
        self.sharedUserSessionRepository = dependencyContainer.sharedUserSessionRepository
        self.sharedMainViewModel = dependencyContainer.sharedMainViewModel
        self.userSession = userSession
        
        self.homeMainViewModel = makeHomeMainViewModel()
    }
}

// MARK: Home View Controller
extension HomeDependencyContainer: HomeViewControllerFactory {
    func makeHomeMainViewController() -> NibLessNavigationController {
        let viewModel = homeMainViewModel
        return HomeMainViewController(viewModel: viewModel, homeViewControllerFactory: self)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        let homeViewController = HomeViewController.makeInstance(viewModel: viewModel, homeContentViewFactory: self)
        homeViewController.navigationItem.title = "Home"
        return homeViewController
    }
    
    private func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(homeViewResponder: homeMainViewModel, userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

// MARK: Home Content View
extension HomeDependencyContainer: HomeContentViewFactory {
    func makeAccountDetailView(
        allMembers: Observable<[UserProfile]>,
        groupDetail: Observable<GroupDetail>,
        isAdmin: Observable<Bool>
    ) -> AccountDetailView {
        let viewModel = makeAccountDetailViewModel(
            allMembers: allMembers,
            groupDetail: groupDetail,
            isAdmin: isAdmin)
        
        let view = AccountDetailView.makeInstance(viewModel: viewModel)
        return view
    }
    
    private func makeAccountDetailViewModel(
        allMembers: Observable<[UserProfile]>,
        groupDetail: Observable<GroupDetail>,
        isAdmin: Observable<Bool>
    ) -> AccountDetailViewModelProtocol {
        return AccountDetailViewModel(allMembers: allMembers, groupDetail: groupDetail, isAdmin: isAdmin)
    }
    
    func makeMemberGraphView(allMembers: Observable<[UserProfile]>) -> MemberGraphView {
        let viewModel = makeMemberGraphViewModel(allMembers: allMembers)
        let view = MemberGraphView.makeInstance(viewModel: viewModel)
        return view
    }
    
    private func makeMemberGraphViewModel(allMembers: Observable<[UserProfile]>) -> MemberGraphViewModelProtocol {
        return MemberGraphViewModel(allMembers: allMembers, userSession: userSession)
    }
    
    func makeNoticeView(notice: Observable<Notice>) -> NoticeView {
        let viewModel = makeNoticeViewModel(notice: notice)
        let view = NoticeView.makeInstance(viewModel: viewModel)
        return view
    }
    
    private func makeNoticeViewModel(notice: Observable<Notice>) -> NoticeViewModelProtocol {
        return NoticeViewModel(notice: notice)
    }
}
