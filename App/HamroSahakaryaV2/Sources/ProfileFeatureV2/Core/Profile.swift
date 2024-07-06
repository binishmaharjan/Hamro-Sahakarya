import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftHelpers

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
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onMemberMenuTapped(.changePicture):
                state.destination = .changePicture(.init(user: state.user))
                return .none
                
            case .onMemberMenuTapped(.changePassword):
                state.destination = .changePassword(.init(user: state.user))
                return .none
                
            case .onMemberMenuTapped(.members):
                state.destination = .membersList(.init())
                return .none
                
            case .onAdminMenuTapped(.expenseAndExtra):
                state.destination = .extraIncomeAndExpenses(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.monthlyFee):
                state.destination = .addMonthlyFee(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.loanMember):
                state.destination = .loanMember(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.loanReturned):
                state.destination = .loanReturned(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.addOrDeduct):
                state.destination = .addOrDeductAmount(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.changeStatus):
                state.destination = .changeMemberStatus(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.removeMember):
                state.destination = .removeMember(.init(admin: state.user))
                return .none
                
            case .onAdminMenuTapped(.updateNotice):
                state.destination = .updateNotice(.init(admin: state.user))
                return .none
                
            case .onOtherMenuTapped(.termsAndCondition):
                state.destination = .termsAndCondition(.init())
                return .none
                
            case .onOtherMenuTapped(.license):
                state.destination = .license(.init())
                return .none
                
            case .onSignOutButtonTapped:
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
