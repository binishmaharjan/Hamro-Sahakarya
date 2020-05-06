//
//  HomeViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/18.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var myBalanceLabel: UILabel!
    @IBOutlet private weak var loanTakenLabel: UILabel!
    @IBOutlet private weak var dateJoinedLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    @IBOutlet private weak var currentHomeContentViewTitleLabel: UILabel!
    @IBOutlet private weak var currentHomeContentViewSubTitleLabel: UILabel!
    @IBOutlet private weak var homeContentScrollView: UIScrollView!
    
    @IBOutlet private weak var memberGraphButtonArea: UIView!
    @IBOutlet private weak var memberGraphButton: UIButton!
    @IBOutlet private weak var accountDetailButtonArea: UIView!
    @IBOutlet private weak var accountDetailButton: UIButton!
    @IBOutlet private weak var monthDetailButtonArea: UIView!
    @IBOutlet private weak var monthDetailButton: UIButton!
    
    @IBOutlet private weak var memberGraphViewArea: UIView!
    @IBOutlet private weak var accountDetailViewArea: UIView!
    @IBOutlet private weak var monthlyDetailViewArea: UIView!
    
    
    // MARK: Properties
    private var viewModel: HomeViewModelProtocol!
    private var homeContentViewFactory: HomeContentViewFactory!
    private let disposeBag: DisposeBag = DisposeBag()
    private let homeContentViewSize: CGFloat = (UIScreen.main.bounds.width - 32)
    private var isFirstLoad: Bool = true
    
    private var accountDetailView: AccountDetailView!

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        bind()
        bindHomeContentView()
        bindApiState()
        
        fetchData()
        
        setupHomeContentView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if homeContentScrollView.contentSize.width != 0  && isFirstLoad {
            isFirstLoad = false
            homeContentScrollView.contentOffset.x = homeContentViewSize
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: Methods
    private func setup() {
        homeContentScrollView.delegate = self
    }
    
    private func setupHomeContentView() {
        // Account Detail View
        accountDetailView = homeContentViewFactory.makeAccountDetailView(allMembers: viewModel.allMembers.asObservable(),
                                                                         groupDetail: viewModel.groupDetail.asObservable())
        accountDetailView.translatesAutoresizingMaskIntoConstraints = false
        accountDetailViewArea.addSubview(accountDetailView)
        NSLayoutConstraint.activate([
            accountDetailView.trailingAnchor.constraint(equalTo: accountDetailViewArea.trailingAnchor),
            accountDetailView.leadingAnchor.constraint(equalTo: accountDetailViewArea.leadingAnchor),
            accountDetailView.topAnchor.constraint(equalTo: accountDetailViewArea.topAnchor),
            accountDetailView.bottomAnchor.constraint(equalTo: accountDetailViewArea.bottomAnchor),
        ])
        accountDetailView.bind()
    }
    
    private func fetchData() {
        viewModel.fetchData()
    }
    
    // MARK: IBActions
    @IBAction func memberGraphButtonPressed(_ sender: Any) {
        viewModel.homeContentView.accept(.memberGraph)
    }
    
    @IBAction func accountDetailButtonPressed(_ sender: Any) {
        viewModel.homeContentView.accept(.accountDetail)
    }
    
    @IBAction func monthlyDetailButtonPressed(_ sender: Any) {
        viewModel.homeContentView.accept(.monthlyDetail)
    }
}

// MARK: Bindable
extension HomeViewController {
    
    private func bindApiState() {
        viewModel.apiState
            .drive(onNext: { (state) in
          
          switch state {
            
          case .completed:
            GUIManager.shared.stopAnimation()
          case .error(let error):
            
            let dropDownModel = DropDownModel(dropDownType: .error, message: error.localizedDescription)
            GUIManager.shared.showDropDownNotification(data: dropDownModel)
            
          case .loading:
            GUIManager.shared.startAnimation()
          default:
            break
          }
        }).disposed(by: disposeBag)
    }
    
    private func bind() {
        // Output
        viewModel.myBalance
            .asDriver(onErrorJustReturn: "¥0")
            .drive(myBalanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.loanTaken
            .asDriver(onErrorJustReturn: "¥0")
            .drive(loanTakenLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateJoined
            .asDriver(onErrorJustReturn: "")
            .drive(dateJoinedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.status
            .asDriver(onErrorJustReturn: .member)
            .map { $0.rawValue }
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.username
            .asDriver(onErrorJustReturn: "")
            .drive(usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.email
            .asDriver(onErrorJustReturn: "")
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindHomeContentView() {
        viewModel.homeContentView
            .startWith(.accountDetail)
            .asObservable()
            .distinctUntilChanged()
            .subscribeNext { [weak self] (contentView) in
                guard let this = self else { return }
                
                this.currentHomeContentViewTitleLabel.text = contentView.title
                this.homeContentScrollView.contentOffset.x = this.homeContentViewSize * CGFloat(contentView.index)
                
                this.accountDetailButtonArea.backgroundColor = (contentView == HomeContentView.accountDetail) ? .mainOrange : .white
                this.accountDetailButton.setImage((contentView == HomeContentView.accountDetail) ?
                    UIImage(named: "icon_account_selected") :
                    UIImage(named: "icon_account_unselected") , for: .normal)
                
                this.memberGraphButtonArea.backgroundColor = (contentView == HomeContentView.memberGraph) ? .mainOrange : .white
                this.memberGraphButton.setImage((contentView == HomeContentView.memberGraph) ?
                UIImage(named: "icon_graph_selected") :
                UIImage(named: "icon_graph_unselected") , for: .normal)
                
                this.monthDetailButtonArea.backgroundColor = (contentView == HomeContentView.monthlyDetail) ? .mainOrange : .white
                this.monthDetailButton.setImage((contentView == HomeContentView.monthlyDetail) ?
                UIImage(named: "icon_detail_selected") :
                UIImage(named: "icon_detail_unselected") , for: .normal)
                
        }.disposed(by: disposeBag)
    }
}

// MARK: Storyboard Instantiable
extension HomeViewController: StoryboardInstantiable {
    
    static func makeInstance(viewModel: HomeViewModelProtocol, homeContentViewFactory: HomeContentViewFactory) -> HomeViewController {
        let viewController = loadFromStoryboard()
        viewController.viewModel = viewModel
        viewController.homeContentViewFactory = homeContentViewFactory
        return viewController
    }
}

// MARK: Storyboard Instantiable
extension HomeViewController: AssociatedHomeView {
    func getAssociateView() -> HomeView {
        return .home
    }
    
}

// MARK: Scroll View Delegate
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let newScrolledIndex: Int = Int(scrollView.contentOffset.x / homeContentViewSize)
        let newHomeContentView: HomeContentView = HomeContentView(rawValue: newScrolledIndex) ?? .accountDetail
        viewModel.homeContentView.accept(newHomeContentView)
    }
}
