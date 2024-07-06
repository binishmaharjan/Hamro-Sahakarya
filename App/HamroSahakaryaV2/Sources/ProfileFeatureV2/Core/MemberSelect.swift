import Foundation
import ComposableArchitecture
import SharedModels

@Reducer
public struct MemberSelect {
    @ObservableState
    public struct State: Equatable {
        public enum Mode: Equatable {
            case all
            case membersOnly
        }
        
        public init(members: [User], mode: Mode) {
            self.members = members
            self.mode = mode

            selectDefaultMember()
        }
        
        var mode: Mode
        var members: [User]
        var selectedMembers: [User] = []
        
        func isAllMemberSelected() -> Bool {
            return selectedMembers.isEmpty
        }
        
        func isSelected(member: User) -> Bool {
            return selectedMembers.contains(member)
        }
        
        /// default select first member on MembersOnly mode.
        private mutating func selectDefaultMember() {
            guard case .membersOnly = mode else {
                return
            }
            guard selectedMembers.isEmpty && !members.isEmpty else {
                return
            }
            // default select first member on MembersOnly mode.
            selectedMembers.append(members[0])
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
                if state.mode == .all {
                    if let index = state.selectedMembers.firstIndex(of: member) {
                        state.selectedMembers.remove(at: index)
                    } else {
                        state.selectedMembers.append(member)
                    }
                } else {
                    state.selectedMembers.removeAll()
                    state.selectedMembers.append(member)
                }
                return .none
            }
        }
    }
}
