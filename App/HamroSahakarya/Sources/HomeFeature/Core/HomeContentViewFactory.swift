import Core
import Foundation
import RxSwift

public protocol HomeContentViewFactory {
    func makeAccountDetailView(
        allMembers: Observable<[UserProfile]>,
        groupDetail: Observable<GroupDetail>,
        isAdmin: Observable<Bool>
    ) -> AccountDetailView
    func makeMemberGraphView(allMembers: Observable<[UserProfile]>) -> MemberGraphView
    func makeNoticeView(notice: Observable<Notice>) -> NoticeView
}
