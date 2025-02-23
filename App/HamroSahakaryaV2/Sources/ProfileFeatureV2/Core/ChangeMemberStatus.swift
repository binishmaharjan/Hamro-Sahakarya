import Foundation
import ComposableArchitecture
import SharedModels
import SharedUIs
import AnalyticsClient

@Reducer
public struct ChangeMemberStatus {
    @Reducer(state: .equatable)
    public enum Destination {
        case alert(AlertState<Alert>)
        
        public enum Alert: Equatable {
            case changeConfimationTapped
        }
    }

    @ObservableState
    public struct State: Equatable {
        public init(admin: User) {
            self.admin = admin
        }
        
        @Presents var destination: Destination.State?
        var admin: User
        var isLoading: Bool = false
        var members: [User] = []
        var memberSelect: MemberSelect.State = MemberSelect.State(members: [], mode: .membersOnly)
        var isStatusChanged: Bool = false
        var isValidInput: Bool {
            return !memberSelect.selectedMembers.isEmpty
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case memberSelect(MemberSelect.Action)
        
        case onAppear
        case membersListResponse(Result<[User], Error>)
        case changeMemberStatusTapped
        case changeMemberStatusResponse(Result<Void, Error>)
    }
    
    public init() { }
    
    @Dependency(\.userApiClient) private var userApiClient
    @Dependency(\.analyticsClient) private var analyticsClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.memberSelect, action: \.memberSelect) {
            MemberSelect()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                handleTrackingEvent(eventType: .screenView)
                guard state.members.isEmpty else { return .none }
                
                state.isLoading = true
                return .run { send in
                    await send(
                        .membersListResponse(
                            Result {
                                try await userApiClient.fetchAllMembers()
                            }
                        )
                    )
                }
                
            case .membersListResponse(.success(let members)):
                state.isLoading = false
                state.members = members
                state.memberSelect = MemberSelect.State(members: members, mode: .membersOnly)
                
                // if flag is true, then show member status chnaged  alert
                if state.isStatusChanged {
                    state.isStatusChanged = false
                    state.destination = .alert(.onUpdateSuccessful())
                }
                
                return .none
                
            case .membersListResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .changeMemberStatusTapped:
                // If no member is selected, do nothing
                guard !state.memberSelect.selectedMembers.isEmpty else { return .none }
                
                // If user  is developer, show alert
                guard state.admin.isUseAdminMenu else {
                    state.destination = .alert(.onNoPermissionAlert())
                    return .none
                }
                
                let selectedMember = state.memberSelect.selectedMembers[0]
                if selectedMember.id == state.admin.id {
                    state.destination = .alert(.actionProhibited())
                } else {
                    state.destination = .alert(.changeMemberStatusConfirmation(currentStatus: selectedMember.status))
                }
                return .none

            case .destination(.presented(.alert(.changeConfimationTapped))):
                guard !state.memberSelect.selectedMembers.isEmpty else { return .none }
                let targetMember = state.memberSelect.selectedMembers[0]
                state.isLoading = true
                return .run { send in
                    await send(
                        .changeMemberStatusResponse(
                            Result {
                                try await userApiClient.changeStatus(for: targetMember)
                            }
                        )
                    )
                }
                
            case .changeMemberStatusResponse(.success):
                // Creating flag to show alert after refetching member
                state.isStatusChanged = true
                return .run { send in
                    await send(
                        .membersListResponse(
                            Result {
                                try await userApiClient.fetchAllMembers()
                            }
                        )
                    )
                }
                
            case .changeMemberStatusResponse(.failure(let error)):
                state.isLoading = false
                state.destination = .alert(.onError(error))
                return .none
                
            case .binding, .destination, .memberSelect:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: AlertState
extension AlertState where Action == ChangeMemberStatus.Destination.Alert {
    static func changeMemberStatusConfirmation(currentStatus: Status) -> AlertState {
        AlertState {
            TextState(#localized("Remove Confirmation"))
        } actions: {
            ButtonState(role: .cancel) {
                TextState(#localized("Cancel"))
            }
            ButtonState(action: .changeConfimationTapped) {
                TextState("Yes, Change")
            }
        } message: {
            TextState(currentStatus.confirmationAlertText)
        }
    }
}

// MARK: Alert + Status
extension Status {
    var confirmationAlertText: String {
        switch self {
        case .member: return "Are you sure you want to promote this member to Status: Admin ?"
        case .admin: return "Are you sure you want to demote this member to Status: Member ?"
        case .developer: return "Some Problem Occurred."
        }
    }
}

// Analytics
extension ChangeMemberStatus {
    enum EventType {
        case screenView
        
        var event: Event {
            switch self {
            case .screenView:
                return .screenView
            }
        }
        
        var actionName: String {
            switch self {
            case .screenView: return ""
            }
        }
    }
    
    private func handleTrackingEvent(eventType: EventType) {
        let parameter = Parameter(screenName: "change_member_status_view", actionName: eventType.actionName)
        analyticsClient.trackEvent(event: eventType.event, parameter: parameter)
    }
}
