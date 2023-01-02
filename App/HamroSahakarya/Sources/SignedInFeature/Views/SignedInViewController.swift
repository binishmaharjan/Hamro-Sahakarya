import AppUI
import RxSwift
import UIKit

public final class SignedInViewController: NibLessViewController {
    // MARK: Properties
    private let viewModel: SignedInViewModel
    private let disposeBag = DisposeBag()

    private let tabBar: UITabBarController

    // MARK: Init
    public init(
        viewModel: SignedInViewModel,
        tabBar: UITabBarController
    ) {
        self.viewModel = viewModel
        self.tabBar = tabBar
        super.init()
    }

    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.view)
    }

    // MARK: Methods
    private func subscribe(to observable: Observable<SignedInView>) {
        observable.distinctUntilChanged()
            .subscribe(onNext: { [weak self] view in
                self?.present(signedInView: view)
            }).disposed(by: disposeBag)
    }
}

// MARK: Presentation
extension SignedInViewController {
    private func present(signedInView: SignedInView) {
        switch signedInView {
        case .tabbar:
            presentTabBar()
        }
    }

    private func presentTabBar() {
        addFullScreen(childViewController: tabBar)
    }
}
