//
//  MemberGraphView.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/09.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class MemberGraphView: UIView {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    private var viewModel: MemberGraphViewModelProtocol!
    private let disposeBag = DisposeBag()
    private func fetchAllMembersFromFirebase() {
        print("awakeFromNib() setup() disposeBag viewModel")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        pieChartView.chartDescription?.text = ""
        pieChartView.legend.enabled = false
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.highlightPerTapEnabled = false
    }
}

//MARK: Bind
extension MemberGraphView {
    
    func bind() {
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
    }
}

//MARK: Xib Instantiable
extension MemberGraphView: HasXib {
    
    static func makeInstance(viewModel: MemberGraphViewModelProtocol) -> MemberGraphView {
        let graphView = MemberGraphView.loadXib()
        graphView.viewModel = viewModel
        return graphView
    }
}
