import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public final class AddOrDeductAmountViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var addOrDeductLabel: UILabel!
    
    //MARK: Properties
    private var viewModel: AddOrDeductAmountViewModelProtocol!
    private var disposeBag =  DisposeBag()
    private var addButton: UIBarButtonItem!
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        bindApiState()
        bindUIState()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchAllMembers()
    }
    
    private func setup() {
        setupNavigation()
        setupTableView()
        setupAddOrDeductActionSheet()
        setupBarButton()
    }
    
    private func setupNavigation() {
        title = "Add Or Deduct Amount"
    }
    
    private func setupTableView() {
        tableView.registerXib(of: MembersCell.self, bundle: .module)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupAddOrDeductActionSheet() {
        let typeSelectionTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeSelectionTapped))
        addOrDeductLabel.addGestureRecognizer(typeSelectionTapGesture)
    }
    
    private func setupBarButton() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addButtonPressed() {
        viewModel.addOrDeduct()
    }
    
    @objc private func typeSelectionTapped() {
        showTypeSelectionSheet()
    }
    
    private func showTypeSelectionSheet() {
        let actionSheet = UIAlertController(title: "Type Selection", message: "Add Or Deduct", preferredStyle: .actionSheet)
        let actions = AddOrDeduct.allCases.map { [weak self] type -> UIAlertAction in
            
            let action = UIAlertAction(title: type.rawValue, style: .default) { (_) in
                self?.viewModel.selectedTypeInput.accept(type)
            }
            
            return action
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actions.forEach { actionSheet.addAction($0) }
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

// MARK: Storyboard Instantiable
extension AddOrDeductAmountViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: AddOrDeductAmountViewModelProtocol) -> AddOrDeductAmountViewController {
        let viewController = AddOrDeductAmountViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        return viewController
    }
}

// MARK: UITableView Data Source
extension AddOrDeductAmountViewController: UITableViewDataSource {
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

// MARK: Bindable
extension AddOrDeductAmountViewController {
    private func bindApiState() {
        viewModel.apiState
            .withLatestFrom(viewModel.addOrDeductSuccessful) { return ($0, $1) }
            .driveNext { [weak self] (state, addOrDeductSuccessful) in
                
                switch state {
                case .completed:
                    if addOrDeductSuccessful {
                        let dropDownModel = DropDownModel(dropDownType: .success, message: "Successful!!!")
                        GUIManager.shared.showDropDownNotification(data: dropDownModel)
                        
                        self?.amountTextField.text = ""
                        self?.viewModel.selectedUser.accept(nil)
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
        // Input
        amountTextField.rx.text
            .asDriver()
            .map { Int($0 ?? "0") ?? 0 }
            .drive(viewModel.amountInput)
            .disposed(by: disposeBag)
        
        // Output
        viewModel
            .isConfirmButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(addButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.selectedTypeInput
            .asDriver(onErrorJustReturn: .add)
            .map { $0.rawValue }
            .drive(addOrDeductLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: UITableView Delegate
extension AddOrDeductAmountViewController: UITableViewDelegate {
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
        viewModel.selectedUser.accept(userProfile)
        
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

//MARK: Associate View
extension AddOrDeductAmountViewController: ViewControllerWithAssociatedView {
    public func getAssociateView() -> ProfileMainView {
        return .addOrDeductAmount
    }
}
