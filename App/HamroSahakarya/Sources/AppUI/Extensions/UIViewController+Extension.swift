import Core
import RxSwift
import UIKit

// MARK: Child Container
extension UIViewController {

    // MARK: - Methods
    public func addFullScreen(childViewController child: UIViewController) {
        guard child.parent == nil else {
            return
        }

        addChild(child)
        view.addSubview(child.view)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: child.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
        ]
        constraints.forEach { $0.isActive = true }
        view.addConstraints(constraints)

        child.didMove(toParent: self)
    }

    public func remove(childViewController child: UIViewController?) {
        guard let child = child else {
            return
        }

        guard child.parent != nil else {
            return
        }

        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

// MARK: Error Presentation
extension UIViewController {

    // MARK: - Methods
    public func present(errorMessage: ErrorMessage) {
        let errorAlertController = UIAlertController(
            title: errorMessage.title,
            message: errorMessage.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }

    public func present(errorMessage: ErrorMessage, withPresentationState errorPresentation: BehaviorSubject<ErrorPresentation?>) {
        errorPresentation.onNext(.presenting)
        let errorAlertController = UIAlertController(
            title: errorMessage.title,
            message: errorMessage.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            errorPresentation.onNext(.dismissed)
            errorPresentation.onNext(nil)
        }
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
}
