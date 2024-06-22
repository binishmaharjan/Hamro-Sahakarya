import Foundation
import SharedModels

/**
Model for combining all the api responses for the Home View.
*/
public struct HomeResponse {
    public init(allMembers: [User], groupDetail: GroupDetail, notice: Notice) {
        self.id = UUID()
        self.allMembers = allMembers
        self.groupDetail = groupDetail
        self.notice = notice
    }
    private let id: UUID
    var allMembers: [User] = [.mock]
    var groupDetail: GroupDetail
    var notice: Notice
}

// MARK: Equatable
extension HomeResponse: Equatable {
    public static func == (lhs: HomeResponse, rhs: HomeResponse) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: Mock
extension HomeResponse {
    static let mock = HomeResponse(
        allMembers: [.mock, .mock2],
        groupDetail: GroupDetail(extra: 50000, expenses: 2500),
        notice: Notice(message: "This is a preview", admin: "Admin", dateCreated: "2020-04-29 05:49:30.864")
    )
}
