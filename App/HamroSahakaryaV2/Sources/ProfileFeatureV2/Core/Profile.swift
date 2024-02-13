import Foundation
import ComposableArchitecture
import SharedModels

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
    }
    
    public enum Action: BindableAction, Equatable {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        
        case onAppear
        case onMemberMenuTapped(Menu.Member)
        case onAdminMenuTapped(Menu.Admin)
        case onOtherMenuTapped(Menu.Other)
        case onSignOutButtonTapped
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none

            case .onMemberMenuTapped(.changePicture):
                return .none
                
            case .onMemberMenuTapped(.changePassword):
                return .none
                
            case .onMemberMenuTapped(.members):
                state.destination = .membersList(.init())
                return .none
                
            case .onAdminMenuTapped(.expenseAndExtra):
                return .none
                
            case .onAdminMenuTapped(.monthlyFee):
                return .none
                
            case .onAdminMenuTapped(.loanMember):
                return .none
                
            case .onAdminMenuTapped(.loanReturned):
                return .none
                
            case .onAdminMenuTapped(.addOrDeduct):
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
                print("onSignOutButtonTapped")
                return .none
                
            case .binding, .destination:
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
            case membersList(MembersList.State)
        }
        
        public enum Action: Equatable {
            case membersList(MembersList.Action)
        }
        
        public init() { }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.membersList, action: \.membersList) {
                MembersList()
            }
        }
    }
}
