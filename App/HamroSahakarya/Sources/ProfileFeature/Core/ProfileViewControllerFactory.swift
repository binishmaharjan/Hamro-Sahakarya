import Foundation

public protocol ProfileViewControllerFactory {
    func makeChangePictureViewController() -> ChangePictureViewController
    func makeMembersViewController() -> MembersViewController
    func makeChangePasswordViewController() -> ChangePasswordViewController
    func makeChangeMemberStatusViewController() -> ChangeMemberStatusViewController
    func makeAddMonthlyFeeViewController() -> AddMonthlyFeeViewController
    func makeExtranAndExpensesViewController() -> ExtraAndExpensesViewController
    func makeLoanMemberViewController() -> LoanMemberViewController
    func makeLoanReturnedViewController() -> LoanReturnedViewController
    func makeRemoveMemberViewController() -> RemoveMemberViewController
    func makeTermsAndConditionViewController() -> TermsAndConditionViewController
    func makeAddOrDeductAmountViewController() -> AddOrDeductAmountViewController
    func makeUpdateNoticeViewController() -> UpdateNoticeViewController
}
