import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift

public enum ProfileRow {
    case top(ProfileTopCellViewModel)
    
    // User
    case changePicture
    case changePassword
    case members
    
    // Admin
    case changeStatus
    case extraAndExpenses
    case monthlyFee
    case loanMember
    case loanReturned
    case removeMember
    case addOrDeductAmount
    
    // Others
    case updateNotice
    case termsAndCondition
    case logout
    
    var title: String {
        switch self {
        case .top(_):
            return ""
        case .changePicture:
            return "Change Picture"
        case .changePassword:
            return "Change Password"
        case .members:
            return "Members"
        case .termsAndCondition:
            return "Terms And Condition"
        case .logout:
            return "Logout"
        case .changeStatus:
            return "Change Status"
        case .extraAndExpenses:
            return "Extra Income And Expenses"
        case .monthlyFee:
            return "Monthly Fee"
        case .loanMember:
            return "Loan a Member"
        case .loanReturned:
            return "Loan Returned"
        case .removeMember:
            return "Remove Member"
        case .addOrDeductAmount:
            return "Add or Deduct Amount"
        case .updateNotice:
            return "Update Notice"
        }
    }
}

public struct ProfileSection {
    let rows: [ProfileRow]
}

public protocol ProfileViewModel {
    var userSession: UserSession { get }
    var notSignedInResponder: NotSignedInResponder { get }
    var numberOfSection: Int { get }
    var lastSection: Int { get }
    var state: Driver<State> { get }
    
    func signOut()
    func navigate(to view: ProfileMainView)
    func numberOfRows(in section: Int) -> Int
    func row(for indexPath: IndexPath) -> ProfileRow
}

public typealias ProfileViewResponder = ProfileMainViewModel

public struct DefaultProfileViewModel: ProfileViewModel {
    // MARK: Properties
    public let userSession: UserSession
    public let notSignedInResponder: NotSignedInResponder
    public let userSessionRepository: UserSessionRepository
    public let profileViewResponder: ProfileViewResponder
    
    // Data Source
    public var profileSections: [ProfileSection] {
        // Making Section
        let topSection =  ProfileSection(rows: [.top(DefaultProfileTopCellViewModel(userSession: userSession))])
        let userSection = ProfileSection(rows: [.changePicture, .changePassword, .members])
        let adminSection = ProfileSection(rows: [.changeStatus, .monthlyFee, .extraAndExpenses, .addOrDeductAmount, .loanMember, .loanReturned,.removeMember, .updateNotice])
        let otherSection = ProfileSection(rows: [.termsAndCondition, .logout])
        
        var section: [ProfileSection] = []
        
        section.append(topSection)
        section.append(userSection)
        if userSession.isAdmin {
            section.append(adminSection)
        }
        section.append(otherSection)
        
        return section
    }
    
    public  var numberOfSection: Int {
        return profileSections.count
    }
    
    public var lastSection: Int {
        return numberOfSection - 1
    }
    
    @PropertyBehaviorRelay<State>(value: .idle)
    public var state: Driver<State>
    
    // MARK: Init
    public init(
        userSession: UserSession,
        notSignedInResponder: NotSignedInResponder,
        userSessionRepository: UserSessionRepository,
        profileViewResponder: ProfileViewResponder
    ) {
        self.userSession = userSession
        self.notSignedInResponder = notSignedInResponder
        self.userSessionRepository = userSessionRepository
        self.profileViewResponder = profileViewResponder
    }
    
    // MARK: Methods
    public func signOut() {
        userSessionRepository.signOut(userSession: userSession)
            .done(indicateSignoutSuccessful)
            .catch(indicateError)
    }
    
    public func numberOfRows(in section: Int) -> Int {
        return profileSections[section].rows.count
    }
    
    public func row(for indexPath: IndexPath) -> ProfileRow {
        return profileSections[indexPath.section].rows[indexPath.row]
    }
    
    private func indicateSignoutSuccessful(userSession: UserSession) {
        notSignedInResponder.notSignedIn()
    }
    
    private func indicateError(error: Error) {
        _state.accept(.error(error))
    }
}

extension DefaultProfileViewModel {
    public func navigate(to view: ProfileMainView) {
        profileViewResponder.navigate(to: view)
    }
}
