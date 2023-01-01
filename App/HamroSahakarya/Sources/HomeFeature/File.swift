import Core
import Foundation
import RxSwift

// TODO: Home Dependency Container
public protocol HomeContentViewFactory {
    func makeAccountDetailView(allMembers: Observable<[UserProfile]>, groupDetail: Observable<GroupDetail>, isAdmin: Observable<Bool>) -> AccountDetailView
    func makeMemberGraphView(allMembers: Observable<[UserProfile]>) -> MemberGraphView
    func makeNoticeView(notice: Observable<Notice>) -> NoticeView
}

public protocol HomeViewControllerFactory {
    func makeHomeViewController() -> HomeViewController
}
