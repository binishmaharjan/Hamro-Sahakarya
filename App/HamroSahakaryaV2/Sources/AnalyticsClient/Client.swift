import Foundation
import ComposableArchitecture

@DependencyClient
public struct AnalyticsClient {
    /// Track Event
    public var trackEvent: (_ event: Event, _ parameter: Parameter) -> Void
}

// Common Paramter and Action Parameter

// MARK: DependencyValues
extension DependencyValues {
    public var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}

// MARK: Dependency (testValue, previewValue)
extension AnalyticsClient: TestDependencyKey {
    public static let testValue = AnalyticsClient(
        trackEvent: unimplemented()
    )

    public static let previewValue = AnalyticsClient(
        trackEvent: unimplemented()
    )
}
