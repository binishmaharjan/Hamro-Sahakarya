import Foundation

public protocol HomeViewControllerFactory {
    func makeHomeViewController() -> HomeViewController
}
