import AppUI
import RxSwift
import UIKit

public protocol AssociatedHomeView {
    func getAssociateView() -> HomeView
}

public final class HomeMainViewController: NibLessNavigationController {
    // MARK: Properties
    private let viewModel: HomeMainViewModelProtocol
    private let disposeBag = DisposeBag()
    private let homeViewControllerFactory: HomeViewControllerFactory
    
    public init(
        viewModel: HomeMainViewModelProtocol,
        homeViewControllerFactory: HomeViewControllerFactory
    ) {
        self.viewModel = viewModel
        self.homeViewControllerFactory = homeViewControllerFactory
        super.init(rootViewController: homeViewControllerFactory.makeHomeViewController())
        
        setup()
    }
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribe(to: viewModel.view)
    }
    
    // MARK: Methods
    private func setup() {
        title = nil
        tabBarItem.image = UIImage(named: "icon_home")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "icon_home_h")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    private func subscribe(to observable: Observable<HomeNavigationAction>) {
        observable.distinctUntilChanged()
            .subscribeNext { [weak self] action in
                guard let this = self else { return }
                this.respond(to: action)
        }.disposed(by: disposeBag)
    }
    
    private func respond(to navigationAction: HomeNavigationAction) {
        switch navigationAction {
            
        case .present:
            break
        case .presented:
            break
        }
    }
}

// MARK: UINavigation Controller Delegate
extension HomeMainViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let shownView = homeView(associatedWith: viewController) else {
            return
        }
        
        viewModel.uiPresented(homeView: shownView)
    }
    
    private func homeView(associatedWith viewController: UIViewController) -> HomeView? {
        guard let viewController = viewController as? AssociatedHomeView else {
            fatalError("ViewController does not have associated view")
        }
        
        return viewController.getAssociateView()
    }
}
