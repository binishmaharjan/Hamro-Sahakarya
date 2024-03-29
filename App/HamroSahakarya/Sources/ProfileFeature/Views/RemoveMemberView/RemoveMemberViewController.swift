import AppUI
import Core
import RxSwift
import UIKit

public final class RemoveMemberViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    private var viewModel: RemoveMemberViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var removeButton: UIBarButtonItem!
    
    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBarButton()
        bindApiState()
        bindUIState()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchAllMembers()
    }
    
    // MARK: Methods
    private func setup() {
        title = "Remove Member"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: MembersCell.self, bundle: .module)
    }
    
    private func setupBarButton() {
        removeButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeButtonPressed))
        navigationItem.rightBarButtonItem = removeButton
    }
    
    @objc private func removeButtonPressed() {
        GUIManager.shared.showDialog(factory: .removeMember) { [weak self] in
            self?.viewModel.removeMember()
        }
    }
}

// MARK: Bindable
extension RemoveMemberViewController {
    private func bindApiState() {
        viewModel.apiState
            .withLatestFrom(viewModel.removeMemberSuccessful) { return ($0, $1) }
            .driveNext { [weak self] (state, removeMemberSuccessful) in
                
                switch state {
                case .completed:
                    if removeMemberSuccessful {
                        let dropDownModel = DropDownModel(dropDownType: .success, message: "Successful!!!")
                        GUIManager.shared.showDropDownNotification(data: dropDownModel)
                        
                        // Refetching the members
                        DispatchQueue.main.async {
                            self?.viewModel.fetchAllMembers()
                        }
                    }
                    
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
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUIState() {
        // Output
        viewModel.isRemoveMemberButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(removeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension RemoveMemberViewController: StoryboardInstantiable {
    public  static func makeInstance(viewModel: RemoveMemberViewModelProtocol) -> RemoveMemberViewController {
        let viewController = RemoveMemberViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: UITableView DataSource
extension RemoveMemberViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MembersCell.self, for: indexPath)
        cell.tintColor = UIColor.mainOrange
        
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        
        cell.accessoryType = isUserSelected(indexPath: indexPath) ? .checkmark : .none
        cell.bind(viewModel: cellViewModel)
        
        return cell
    }
    
    private func isUserSelected(indexPath: IndexPath) -> Bool {
        let member = viewModel.userProfileForRow(at: indexPath)
        return viewModel.isUserSelected(userProfile: member)
    }
}

// MARK: UITableView Delegate
extension RemoveMemberViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members"
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userProfile = viewModel.userProfileForRow(at: indexPath)
        viewModel.selectedMember.accept(userProfile)
        
        let visibleIndexPath = tableView.indexPathsForVisibleRows ?? []
        let visibleCell = tableView.visibleCells as! [MembersCell]
        zip(visibleIndexPath, visibleCell).forEach { (indexPath, cell) in
            reloadCell(cell, indexPath: indexPath)
        }
    }
    
    private func reloadCell(_ cell: MembersCell, indexPath: IndexPath) {
        cell.bind(viewModel: viewModel.viewModelForRow(at: indexPath))
        cell.accessoryType = isUserSelected(indexPath: indexPath) ? .checkmark : .none
    }
}

// MARK: Associated View
extension RemoveMemberViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .removeMember
    }
}
