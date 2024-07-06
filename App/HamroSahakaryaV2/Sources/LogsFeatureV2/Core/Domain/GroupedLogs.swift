import Foundation
import SharedModels

public struct GroupedLogs: Hashable {
    var title: String
    var logs: [GroupLog]
}

extension GroupedLogs {
    init(element: Dictionary<String, [GroupLog]>.Element) {
        self.title = element.key
        self.logs = element.value
    }
}
