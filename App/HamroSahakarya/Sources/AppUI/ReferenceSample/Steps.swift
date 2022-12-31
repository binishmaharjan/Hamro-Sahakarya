import Core
import Foundation

final class Steps: CustomDebugStringConvertible {
    let name: String
    init(name: String) {
        self.name = name
    }

    private struct Item {
        var label: String
        var block: ((Steps) -> Void)
    }
    private var items: [Item] = [Item]()
    private var labels = Set<String>()
    private var current: Int = -1

    var debugDescription: String {
        return "Steps.name = \(name), current = \(current), items.count=\(items.count), items=\(items.map { $0.label }.joined(separator: ", "))"
    }

    // MARK: Add Entry
    @discardableResult
    func label(_ label: String = "", handler: @escaping (Steps) -> Void) -> Steps {
        items.append(Item(label: label, block: handler))

        if label.contains(label) {
            DebugLog("Steps(\(name)) is duplicated. This will be ignored")
        } else {
            labels.insert(label)
        }

        return self
    }

    // MARK: Execute
    private func next(index: Int) {
        current = index
        if let item = items[optional: current] {
            DebugLog("Steps(\(name)) => label(\(item.label))")
            item.block(self)
        } else {
            DebugLog("Steps(\(name)) => index(\(current)) is out of range!")
        }
    }

    func next() {
        next(index: current + 1)
    }

    func next(to label: String) {
        items.enumerated().forEach { (index, item) in
            if item.label == label {
                next(index: index)
            }
        }
    }

    func join(_ finalLabel: String = "end_of_steps!") {
        label(finalLabel) { _ in }.next()
    }
}
