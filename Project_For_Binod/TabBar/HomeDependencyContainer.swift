//
//  HomeDependencyContainer.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/04/25.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation

final class HomeDependencyContainer {
    
    //MARK: Properties
    private let sharedUserSessionRepository: UserSessionRepository
    private let sharedMainViewModel: MainViewModel
    private let userSession: UserSession
    
    private let homeMainViewModel: HomeMainViewModel
    
    // MARK: Init
    init(dependecyContainer: SignedInDepedencyConatiner, userSession: UserSession) {
        func makeHomeMainViewModel() -> HomeMainViewModel {
            return HomeMainViewModel()
        }
        
        self.sharedUserSessionRepository = dependecyContainer.sharedUserSessionRepository
        self.sharedMainViewModel = dependecyContainer.sharedMainViewModel
        self.userSession = userSession
        
        self.homeMainViewModel = makeHomeMainViewModel()
    }
}


protocol HomeViewControllerFactory {
    
    func makeHomeViewController() -> HomeViewController
}

protocol HomeContentViewFactory {
    
    func makeAccountDetailView(allMembers: Observable<[UserProfile]>, groupDetail: Observable<GroupDetail>, isAdmin: Observable<Bool>) -> AccountDetailView
    func makeMemberGraphView(allMembers: Observable<[UserProfile]>) -> MemberGraphView
    func makeNoticeView(notice: Observable<Notice>) -> NoticeView
}

// MARK: Home View Controller
extension HomeDependencyContainer: HomeViewControllerFactory {
    
    func makeHomeMainViewController() -> NiblessNavigationController {
        let viewModel = homeMainViewModel
        return HomeMainViewController(viewModel: viewModel, homeViewControllerFactory: self)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        let homeViewController = HomeViewController.makeInstance(viewModel: viewModel, homeContentViewFactory: self)
        homeViewController.navigationItem.title = "Home"
        return homeViewController
    }
    
    func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(homeViewResponder: homeMainViewModel, userSessionRepository: sharedUserSessionRepository, userSession: userSession)
    }
}

import RxSwift
extension HomeDependencyContainer: HomeContentViewFactory {
    
    func makeAccountDetailView(allMembers: Observable<[UserProfile]>, groupDetail: Observable<GroupDetail>, isAdmin: Observable<Bool>) -> AccountDetailView {
        let viewModel = makeAccountDetailViewModel(allMembers: allMembers, groupDetail: groupDetail, isAdmin: isAdmin)
        let view = AccountDetailView.makeInstance(viewModel: viewModel)
        return view
    }
    
    func makeAccountDetailViewModel(allMembers: Observable<[UserProfile]>, groupDetail: Observable<GroupDetail>, isAdmin: Observable<Bool>) -> AccountDetailViewModelProtocol {
        return AccountDetailViewModel(allMembers: allMembers, groupDetail: groupDetail, isAdmin: isAdmin)
    }
    
    func makeMemberGraphView(allMembers: Observable<[UserProfile]>) -> MemberGraphView {
        let viewModel = makeMemberGraphViewModel(allMembers: allMembers)
        let view = MemberGraphView.makeInstance(viewModel: viewModel)
        return view
    }
    
    func makeMemberGraphViewModel(allMembers: Observable<[UserProfile]>) -> MemberGraphViewModelProtocol {
        return MemberGraphViewModel(allMembers: allMembers, userSession: userSession)
    }
    
    func makeNoticeView(notice: Observable<Notice>) -> NoticeView {
        let viewModel = makeNoticeViewModel(notice: notice)
        let view = NoticeView.makeInstance(viewModel: viewModel)
        return view
    }
    
    func makeNoticeViewModel(notice: Observable<Notice>) -> NoticeViewModelProtocol {
        return NoticeViewModel(notice: notice)
    }
}
