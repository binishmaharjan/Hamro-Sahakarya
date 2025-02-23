import Foundation

public struct Parameter {
    var screenName: String
    var actionName: String?
    
    public init(screenName: String, actionName: String? = nil) {
        self.screenName = screenName
        self.actionName = actionName
    }
}
