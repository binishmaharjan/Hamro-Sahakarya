import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public final class ChangeMemberStatusViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet private weak var tableView: UITableView!

    private var viewModel: ChangeMemberStatusViewModel!
    private let disposeBag = DisposeBag()

    // MARK: Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindApiState()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getAllMembers()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerXib(of: MembersCell.self, bundle: .module)
    }
}

// MARK: Binding
extension ChangeMemberStatusViewController {
    private func bindApiState() {
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

// MARK: Storyboard Instantiable
extension ChangeMemberStatusViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: ChangeMemberStatusViewModel) -> ChangeMemberStatusViewController {
        let viewController = ChangeMemberStatusViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: UITableView DataSource
extension ChangeMemberStatusViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getStatus(for: section).rawValue
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let numberOfRows = viewModel.numberOfRows(for: section)
        return numberOfRows == 0 ? 0 : 24
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let isUpgrade = viewModel.isUpgradeForMember(at: indexPath)
        GUIManager.shared.showDialog(factory: .changeAdminStatus(isUpgrade)) { [weak self] in
            self?.viewModel.changeStatusForMember(at: indexPath)
        }
    }
}

// MARK: UITableView DataSource
extension ChangeMemberStatusViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(for: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        cell.bind(viewModel: cellViewModel)
        return cell
    }
}

// MARK: Get Associated View
extension ChangeMemberStatusViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .changeMemberStatus
    }
}
