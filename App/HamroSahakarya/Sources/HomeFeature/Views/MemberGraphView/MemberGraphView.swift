import AppUI
import Core
import Charts
import RxCocoa
import RxSwift
import UIKit

public final class MemberGraphView: UIView {
    // MARK: IBOutlet
    @IBOutlet private weak var pieChartView: PieChartView!
    @IBOutlet private weak var memberGraphLegendStackView: UIStackView!
    
    private var viewModel: MemberGraphViewModelProtocol!
    private let disposeBag = DisposeBag()
    private let legendTitleTag = 1
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        pieChartView.chartDescription.text = ""
        pieChartView.legend.enabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.highlightPerTapEnabled = false
    }
}

// MARK: Bind
extension MemberGraphView {
    public func bind() {
        viewModel
            .pieChartData
            .asDriver()
            .driveNext { [weak self] (pieChartData) in
                
                self?.pieChartView.data = pieChartData
                
            }.disposed(by: disposeBag)
        
        viewModel.pieChartUserHighlightX
            .asDriver()
            .driveNext { (x) in
                self.pieChartView.highlightValue(x: x, dataSetIndex: 0)
            }.disposed(by: disposeBag)
        
        viewModel.allMembers
            .asDriver()
            .driveNext(setupMemberGraphLegend(allMembers:))
            .disposed(by: disposeBag)
    }
}

// MARK: Member Graph Legend View
extension MemberGraphView {
    private func setupMemberGraphLegend(allMembers: [UserProfile]) {
        removeAllViewsExpectLegendTitle()
        recreateLegendViews(allMembers: allMembers)
    }
    
    private func removeAllViewsExpectLegendTitle() {
        let legendViewsExcludingTitle = memberGraphLegendStackView.subviews.filter { $0.tag != legendTitleTag }
        legendViewsExcludingTitle.forEach { $0.removeFromSuperview() }
    }
    
    private func recreateLegendViews(allMembers: [UserProfile]) {
        allMembers.forEach { (member) in
            let legendView = createLegend(for: member)
            memberGraphLegendStackView.addArrangedSubview(legendView)
            setupLegendViewConstraints(for: legendView)
        }
    }
    
    private func createLegend(for member: UserProfile) -> MemberGraphLegendView {
        let legendView = MemberGraphLegendView.makeInstance(userProfile: member, isSelf: viewModel.checkIsSelf(for: member))
        return legendView
    }
    
    private func setupLegendViewConstraints(for legendView: MemberGraphLegendView) {
        legendView.width = memberGraphLegendStackView.width
    }
}

//MARK: Xib Instantiable
extension MemberGraphView: HasXib {
    public static func makeInstance(viewModel: MemberGraphViewModelProtocol) -> MemberGraphView {
        let graphView = MemberGraphView.loadXib(bundle: .module)
        graphView.viewModel = viewModel
        return graphView
    }
}
