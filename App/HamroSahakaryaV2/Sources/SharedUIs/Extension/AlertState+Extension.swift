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
}
