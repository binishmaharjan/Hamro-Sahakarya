import AppUI
import Core
import RxCocoa
import RxSwift
import UIKit

public final class LogViewController: UIViewController {
    // MARK: IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noLogView: UIView!
    
    private var viewModel: LogViewModel!
    private let disposeBag = DisposeBag()
    private var refreshButton: UIBarButtonItem!

    // MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindApiState()
        setupBarButton()
        
        tableView.registerXib(of: LogViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.fetchLogs(isRefresh: false)
    }
    
    // MARK: Methods
    private func setup() {
        title = nil
        navigationItem.title = "Logs"
        tabBarItem.image = UIImage(named: "icon_log")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.selectedImage = UIImage(named: "icon_log_h")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    private func setupBarButton() {
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed))
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc private func refreshButtonPressed() {
        viewModel.fetchLogs(isRefresh: true)
    }
}

// MARK: Bind
extension LogViewController {
    private func bindApiState() {
        viewModel.state
            .withLatestFrom(viewModel.isRefreshing) { return ($0, $1) }
            .drive(onNext: { [weak self] (state, isRefreshing) in
                switch state {
                case .idle:
                    break
                case .completed:
                    self?.tableView.reloadData()
                    GUIManager.shared.stopAnimation()
                    
                    if isRefreshing {
                        self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                    
                case .error(let error):
                    GUIManager.shared.stopAnimation()
                    
                    let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
                    GUIManager.shared.showDropDownNotification(data: dropDownModel)
                    
                case .loading:
                    GUIManager.shared.startAnimation()
                }
            }
            ).disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension LogViewController: StoryboardInstantiable {
    public static func makeInstance(viewModel: LogViewModel) -> LogViewController {
        let viewController = LogViewController.loadFromStoryboard(bundle: .module)
        viewController.viewModel = viewModel
        viewController.setup()
        return viewController
    }
}

// MARK: Table View DataSource
extension LogViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noLogView.isHidden = viewModel.count == 0 ? false : true
        return viewModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(of: LogViewCell.self, for: indexPath)
        cell.bind(viewModel: viewModel.logViewModelForRow(at: indexPath))
        return cell
    }
}

// MARK: Table View Delegate
extension LogViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let startFetchingMoreLogIndex = viewModel.count - viewModel.lastCount - 1
        if indexPath.row == startFetchingMoreLogIndex {
            viewModel.fetchMoreLogs()
        }
    }
}
