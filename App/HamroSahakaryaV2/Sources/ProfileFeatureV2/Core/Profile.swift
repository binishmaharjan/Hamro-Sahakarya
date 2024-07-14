import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftHelpers
import AnalyticsClient

@Reducer
public struct Profile {
    @Reducer(state: .equatable)
    public enum Destination {
        case membersList(MembersList)
        case changePicture(ChangePicture)
        case changePassword(ChangePassword)
        case extraIncomeAndExpenses(ExtraIncomeAndExpenses)
        case addMonthlyFee(AddMonthlyFee)
        case loanMember(LoanMember)
        case loanReturned(LoanReturned)
        case addOrDeductAmount(AddOrDeductAmount)
        case changeMemberStatus(ChangeMemberStatus)
        case removeMember(RemoveMember)
        case updateNotice(UpdateNotice)
        case license(License)
        case termsAndCondition(TermsAndCondition)
    }
    
    public enum Alert: Equatable { }
    
    @ObservableState @dynamicMemberLookup
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
        }
        
        public subscript<T>(dynamicMember keyPath: KeyPath<User, T>) -> T {
            return user[keyPath: keyPath]
        }
        
        @Presents var destination: Destination.State?
        @Presents var alert: AlertState<Alert>?
        public var user: User
        public var isLoading: Bool = false
    }
    
    public enum Action: BindableAction {
        public enum Delegate: Equatable {
            case signOutSuccessful
        }
        case destination(PresentationAction<Destination.Action>)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        case onAppear
        case onMemberMenuTapped(Menu.Member)
        case onAdminMenuTapped(Menu.Admin)
        case onOtherMenuTapped(Menu.Other)
        case onSignOutButtonTapped
        case signOutUser
        case signOutResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.userSessionClient) private var userSessionClient
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                return .none
                
            case .onMemberMenuTapped(.changePicture):
                handleTrackingEvent(eventType: .tapChangePicture)
                state.destination = .changePicture(.init(user: state.user))
                return .none
                
            case .onMemberMenuTapped(.changePassword):
                handleTrackingEvent(eventType: .tapChangePassword)
                state.destination = .changePassword(.init(user: state.user))
                return .none
                
            case .onMemberMenuTapped(.members):
                handleTrackingEvent(eventType: .tapMembers)
                state.destination = .membersList(.init())
                return .none
                
            case .onAdminMenuTapped(.expenseAndExtra):
                handleTrackingEvent(eventType: .tapExtraAndExpenses)
                state.destination = .extraIncomeAndExpenses(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.monthlyFee):
                handleTrackingEvent(eventType: .tapAddMonthlyFee)
                state.destination = .addMonthlyFee(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.loanMember):
                handleTrackingEvent(eventType: .tapLoanMember)
                state.destination = .loanMember(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.loanReturned):
                handleTrackingEvent(eventType: .tapLoanReturned)
                state.destination = .loanReturned(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.addOrDeduct):
                handleTrackingEvent(eventType: .tapAddOrDeductAmount)
                state.destination = .addOrDeductAmount(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.changeStatus):
                handleTrackingEvent(eventType: .tapChangeMemberStatus)
                state.destination = .changeMemberStatus(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.removeMember):
                handleTrackingEvent(eventType: .tapRemoveMember)
                state.destination = .removeMember(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.updateNotice):
                handleTrackingEvent(eventType: .tapUpdateNotice)
                state.destination = .updateNotice(.init(admin: state.user))
                return .none
                
            case .onOtherMenuTapped(.termsAndCondition):
                handleTrackingEvent(eventType: .tapTermsAndCondition)
                state.destination = .termsAndCondition(.init())
                return .none
                
            case .onOtherMenuTapped(.license):
                handleTrackingEvent(eventType: .tapLicense)
                state.destination = .license(.init())
                return .none
                
            case .onSignOutButtonTapped:
                handleTrackingEvent(eventType: .tapSignOut)
                return .send(.signOutUser)
                
            case .signOutUser:
                state.isLoading = true
                return .run { send in
                    await send(
                        .signOutResponse(
                            Result { try await userApiClient.signOut() }
                        )
                    )
                }
                
            case .signOutResponse(.success):
                state.isLoading = false
                return .send(.delegate(.signOutSuccessful))
                
            case .signOutResponse(.failure(let error)):
                state.isLoading = false
                state.alert = .onError(error)
                return .none
                
            case .destination(.presented(.changePicture(.delegate(.changeImageSuccessful)))):
                if let updateUser = userSessionClient.read() {
                    state.user = updateUser
                }
                return .none
                
            case .binding, .destination, .delegate, .alert:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
    }
}

// Analytics
extension Profile {
    enum EventType {
        case screenView
        case tapChangePicture
        case tapChangePassword
        case tapMembers
        case tapExtraAndExpenses
        case tapAddMonthlyFee
        case tapLoanMember
        case tapLoanReturned
        case tapAddOrDeductAmount
        case tapChangeMemberStatus
        case tapRemoveMember
        case tapUpdateNotice
        case tapTermsAndCondition
        case tapLicense
        case tapSignOut
        
        var event: Event {
            switch self {
            case .screenView:
                return .screenView
            case .tapChangePicture, .tapChangePassword, .tapMembers, .tapExtraAndExpenses,
                    .tapAddMonthlyFee, .tapLoanMember, .tapLoanReturned, .tapAddOrDeductAmount,
                    .tapChangeMemberStatus, .tapRemoveMember, .tapUpdateNotice, .tapTermsAndCondition,
                    .tapLicense, .tapSignOut:
                return .buttonTap
            }
        }
        
        var actionName: String {
            switch self {
            case .screenView: return ""
            case .tapChangePicture: return "change_picture"
            case .tapChangePassword: return "change_password"
            case .tapMembers: return "members"
            case .tapExtraAndExpenses: return "extra_and_expenses"
            case .tapAddMonthlyFee: return "monthly_fee"
            case .tapLoanMember: return "loan_member"
            case .tapLoanReturned: return "loan_returned"
            case .tapAddOrDeductAmount: return "add_or_deduct_amount"
            case .tapChangeMemberStatus: return "change_member_status"
            case .tapRemoveMember: return "remove_member"
            case .tapUpdateNotice: return "notice"
            case .tapTermsAndCondition: return "terms_and_condtion"
            case .tapLicense: return "license"
            case .tapSignOut: return "signout"
            }
        }
    }
    
    private func handleTrackingEvent(eventType: EventType) {
        let parameter = Parameter(screenName: "profile_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
