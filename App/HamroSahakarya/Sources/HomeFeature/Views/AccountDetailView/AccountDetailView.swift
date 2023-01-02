import AppUI
import RxCocoa
import RxSwift
import UIKit

public final class AccountDetailView: UIView {
    // MARK: IBOutlets
    @IBOutlet private weak var currentBalanceLabel: UILabel!
    @IBOutlet private weak var totalCollectionLabel: UILabel!
    @IBOutlet private weak var loanGivenLabel: UILabel!
    @IBOutlet private weak var extraIncomeLabel: UILabel!
    @IBOutlet private weak var expensesLabel: UILabel!
    @IBOutlet private weak var profitLabel: UILabel!
    @IBOutlet private weak var profitDisplayLabel: UILabel!
    @IBOutlet private weak var extraIncomeView: UIView!
    @IBOutlet private weak var expensesView: UIView!
    
    // MARK: Properties
    private var viewModel: AccountDetailViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Bindable
    public func bind() {
        // Output
        viewModel.currentBalance
            .map { $0.currency }
            .bind(to: currentBalanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalCollection
            .map { $0.currency }
            .bind(to: totalCollectionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalLoanGiven
            .map { $0.currency }
            .bind(to: loanGivenLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.extraIncome
            .map { $0.currency }
            .bind(to: extraIncomeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.expenses
            .map { $0.currency }
            .bind(to: expensesLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.profit
            .map { $0.currency }
            .bind(to: profitLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.shouldHideExtraInfo
            .bind(to: expensesView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.shouldHideExtraInfo
            .bind(to: extraIncomeView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.profitLabelColor
            .bind(onNext: { [weak self] color in
                self?.profitLabel.textColor = color
            })
            .disposed(by: disposeBag)
        
        viewModel
            .profitDisplayText
            .bind(to: profitDisplayLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: Xib Instantiable
extension AccountDetailView: HasXib {
    
    public static func makeInstance(viewModel: AccountDetailViewModelProtocol) -> AccountDetailView {
        let view = AccountDetailView.loadXib(bundle: .module)
        view.viewModel = viewModel
        return view
    }
}
