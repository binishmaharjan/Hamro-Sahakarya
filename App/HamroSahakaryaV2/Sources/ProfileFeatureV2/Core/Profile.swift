import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import SwiftHelpers

@Reducer
public struct Profile {
    @ObservableState @dynamicMemberLookup
    public struct State: Equatable {
        public init(user: User) {
            self.user = user
        }
        
        public subscript<T>(dynamicMember keyPath: KeyPath<User, T>) -> T {
            return user[keyPath: keyPath]
        }
        
        @Presents var destination: Destination.State?
        public var user: User
        public var isLoading: Bool = false
    }
    
    public enum Action: BindableAction {
        public enum Delegate: Equatable {
            case signOutSuccessful
        }
        case destination(PresentationAction<Destination.Action>)
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
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onMemberMenuTapped(.changePicture):
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
                return .none
                
            case .onAdminMenuTapped(.removeMember):
                return .none
                
            case .onAdminMenuTapped(.updateNotice):
                return .none
                
            case .onOtherMenuTapped(.termsAndCondition):
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
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination, .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// MARK: Destination
extension Profile {
    @Reducer
    public struct Destination {
        @ObservableState
        public enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case membersList(MembersList.State)
            case changePassword(ChangePassword.State)
            case extraIncomeAndExpenses(ExtraIncomeAndExpenses.State)
            case addMonthlyFee(AddMonthlyFee.State)
            case loanMember(LoanMember.State)
            case loanReturned(LoanReturned.State)
            case addOrDeductAmount(AddOrDeductAmount.State)
        }
        
        public enum Action {
            public enum Alert: Equatable { }
            
            case alert(Alert)
            case membersList(MembersList.Action)
            case changePassword(ChangePassword.Action)
            case extraIncomeAndExpenses(ExtraIncomeAndExpenses.Action)
            case addMonthlyFee(AddMonthlyFee.Action)
            case loanMember(LoanMember.Action)
            case loanReturned(LoanReturned.Action)
            case addOrDeductAmount(AddOrDeductAmount.Action)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.membersList, action: \.membersList) {
                MembersList()
            }
            Scope(state: \.changePassword, action: \.changePassword) {
                ChangePassword()
            }
            Scope(state: \.extraIncomeAndExpenses, action: \.extraIncomeAndExpenses) {
                ExtraIncomeAndExpenses()
            }
            Scope(state: \.addMonthlyFee, action: \.addMonthlyFee) {
                AddMonthlyFee()
            }
            Scope(state: \.loanMember, action: \.loanMember) {
                LoanMember()
            }
            Scope(state: \.loanReturned, action: \.loanReturned) {
                LoanReturned()
            }
            Scope(state: \.addOrDeductAmount, action: \.addOrDeductAmount) {
                AddOrDeductAmount()
            }
        }
    }
}
