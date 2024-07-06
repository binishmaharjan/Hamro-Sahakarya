import Foundation
import ComposableArchitecture

extension AlertState {
    /// Common Alert for error
    public static func onError(_ error: Error) -> AlertState {
        AlertState {
            TextState(#localized("Error"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(error.localizedDescription)
        }
    }
    
    /// Common Alert for api success
    public static func onUpdateSuccessful() -> AlertState {
        AlertState {
            TextState(#localized("Success"))
        } actions: {
            ButtonState { TextState(#localized("Ok")) }
        } message: {
            TextState(#localized("Update Successful"))
        }
    }

    /// Common Alert for action prohibited
    public static func actionProhibited() -> AlertState {
        AlertState {
            TextState(#localized("Action Prohibited"))
        } actions: {
            ButtonState(role: .cancel) {
                TextState(#localized("Ok"))
            }
        } message: {
            TextState(#localized("This action is prohibited. You cannot remove yourself or change your own status."))
        }
    }
    
}
