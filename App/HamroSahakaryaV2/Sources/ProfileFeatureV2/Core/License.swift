import Foundation
import ComposableArchitecture

@Reducer
public struct License {
    @ObservableState
    public struct State: Equatable {
        public init() { }
        var licenses = LicensePlugin.licenses
    }
    
    public init() { }
}
