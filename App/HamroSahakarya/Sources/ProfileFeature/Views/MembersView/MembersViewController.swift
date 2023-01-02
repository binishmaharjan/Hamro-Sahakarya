import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public final class MembersViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: MembersViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindUIState()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllMembers()
    }
    
    // MARK: Methods
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: MembersCell.self, bundle: .module)
        
        title = "Members"
    }
}

// MARK: Bind State
extension MembersViewController {
    private func bindUIState() {
        viewModel.apiState.drive(onNext: { [weak self] (state) in
            switch state {
            case .completed:
                self?.tableView.reloadData()
                GUIManager.shared.stopAnimation()
            case .error(let error):
                
                let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                GUIManager.shared.showDropDownNotification(data: dropDownModel)
                
                GUIManager.shared.stopAnimation()
            case .loading:
                GUIManager.shared.startAnimation()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: StoryboardInstantiable
extension MembersViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: MembersViewModel) -> MembersViewController {
        let viewController = MembersViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: TableView Delegate
extension MembersViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: TableView Datasource
extension MembersViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        cell.bind(viewModel: cellViewModel)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: Get Associated View
extension MembersViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .members
    }
}
