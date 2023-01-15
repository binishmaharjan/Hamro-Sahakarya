import AppUI
import RxCocoa
import RxSwift
import UIKit

public protocol LaunchViewModelFactory {
    func makeLaunchViewModel() -> LaunchViewModel
}

public final class LaunchViewController: NibLessViewController {
    // MARK: Properties
    private let viewModel: LaunchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    public init(launchViewModelFactory: LaunchViewModelFactory) {
        self.viewModel = launchViewModelFactory.makeLaunchViewModel()
        super.init()
    }
    
    // MARK: Methods
    public override func loadView() {
        view = LaunchRootView.makeInstance(viewModel: viewModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessage()
    }
    
    private func observeErrorMessage() {
        viewModel.errorMessage
            .asDriver { _ in fatalError("Unexpected Error on Launch View") }
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.present(errorMessage: errorMessage,
                             withPresentationState: self.viewModel.errorPresentation)
            })
            .disposed(by: disposeBag)
    }
}
