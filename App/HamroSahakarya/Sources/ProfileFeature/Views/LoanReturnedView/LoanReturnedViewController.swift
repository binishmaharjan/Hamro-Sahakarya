import AppUI
import Core
import Foundation
import RxCocoa
import RxSwift
import UIKit

public final class LoanReturnedViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: LoanReturnedViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var addButton: UIBarButtonItem!
    
    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBarButton()
        bindApiState()
        bindState()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getAllMembersWithLoan()
    }
    
    private func setup() {
        title = "Loan Return"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerXib(of: MemberWithLoanCell.self, bundle: .module)
    }
    
    private func setupBarButton() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonPressed() {
        viewModel.returnAmount()
    }
}

// MARK: Storyboard Instantiable
extension LoanReturnedViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: LoanReturnedViewModelProtocol) -> LoanReturnedViewController {
        let viewController = LoanReturnedViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: Binding
extension LoanReturnedViewController {
    private func bindApiState() {
        viewModel.apiState
            .withLatestFrom(viewModel.returnedAmountSuccessful) { return ($0, $1) }
            .driveNext { [weak self] (state, returnedSuccessful) in
                
                switch state {
                case .completed:
                    if returnedSuccessful {
                        let dropDownModel = DropDownModel(dropDownType: .success, message: "Successful!!!")
                        GUIManager.shared.showDropDownNotification(data: dropDownModel)
                        
                        self?.amountTextField.text = ""
                        
                        // Refetching the members
                        DispatchQueue.main.async {
                            self?.viewModel.getAllMembersWithLoan()
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
    
    private func bindState() {
        // Input
        amountTextField.rx.text
            .asDriver()
            .map { Int($0 ?? "0") ?? 0 }
            .drive(viewModel.returnedAmount)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.isReturnAmountButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: UITableView Data Soure
extension LoanReturnedViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: MemberWithLoanCell.self, for: indexPath)
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
extension LoanReturnedViewController: UITableViewDelegate {
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
        let visibleCell = tableView.visibleCells as! [MemberWithLoanCell]
        zip(visibleIndexPath, visibleCell).forEach { (indexPath, cell) in
            reloadCell(cell, indexPath: indexPath)
        }
    }
    
    private func reloadCell(_ cell: MemberWithLoanCell, indexPath: IndexPath) {
        cell.bind(viewModel: viewModel.viewModelForRow(at: indexPath))
        cell.accessoryType = isUserSelected(indexPath: indexPath) ? .checkmark : .none
    }
}

// MARK: Get Associated View
extension LoanReturnedViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .loanReturned
    }
}
