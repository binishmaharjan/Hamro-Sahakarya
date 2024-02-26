import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct MemberSelect {
    @ObservableState
    public struct State: Equatable {
        public init(members: [User]) {
            self.members = members
        }
        
        var members: [User]
        var selectedMembers: [User] = []
        
        func isAllMemberSelected() -> Bool {
            return selectedMembers.isEmpty
        }
        
        func isSelected(member: User) -> Bool {
            return selectedMembers.contains(member)
        }
    }
    
    public enum Action {
        public enum SelectionType: Equatable {
            case all
            case member(User)
        }
        
        case rowSelected(SelectionType)
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .rowSelected(.all):
                state.selectedMembers = []
                return .none
                
            case .rowSelected(.member(let member)):
                if let index = state.selectedMembers.firstIndex(of: member) {
                    state.selectedMembers.remove(at: index)
                } else {
                    state.selectedMembers.append(member)
                }
                return .none
            }
        }
    }
}
