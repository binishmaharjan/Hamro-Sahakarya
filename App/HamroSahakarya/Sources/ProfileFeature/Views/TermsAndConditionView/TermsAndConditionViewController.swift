import AppUI
import Core
import PDFKit
import RxCocoa
import RxSwift
import UIKit

public final class TermsAndConditionViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var pdfView: PDFView!
    
    // MARK: Properties
    private var viewModel: TermsAndConditionViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bindApiState()
    }
    
    private func setup() {
        title = "Terms And Conditions"
        
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
    }
}

// MARK: Bindable
private extension TermsAndConditionViewController {
    func bindApiState() {
        viewModel.apiState
            .driveNext { state in
                switch state {
                case .completed:
                    GUIManager.shared.stopAnimation()
                case .loading:
                    GUIManager.shared.startAnimation()
                case .error(let error):
                    let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                    GUIManager.shared.showDropDownNotification(data: dropDownModel)
                    
                    GUIManager.shared.stopAnimation()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.pdfDocument
            .bind(onNext: { [weak self] pdf in
                self?.pdfView.document = pdf
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension TermsAndConditionViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: TermsAndConditionViewModelProtocol) -> TermsAndConditionViewController {
        let viewController = TermsAndConditionViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Associated View
extension TermsAndConditionViewController: ViewControllerWithAssociatedView {
    public  func getAssociateView() -> ProfileMainView {
        return .termsAndCondition
    }
}
