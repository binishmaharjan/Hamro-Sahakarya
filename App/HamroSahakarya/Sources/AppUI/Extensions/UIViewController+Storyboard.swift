import UIKit

public protocol StoryboardInstantiable {
    static var className: String { get }
    static func loadFromStoryboard() -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    public static var className: String {
        return String(describing: Self.self)
    }

    public static func loadFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: className, bundle: Bundle.module)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("Could not instantiate ViewController: \(className)")
        }

        return viewController
    }
}
