import Core
import Charts
import Foundation
import RxCocoa
import RxSwift
import UIKit

public protocol MemberGraphViewModelProtocol {
    var allMembers: Observable<[UserProfile]> { get }
    var pieChartData: Observable<PieChartData>{ get }
    var pieChartUserHighlightX: Observable<Double> { get }
    
    func checkIsSelf(for userProfile: UserProfile) -> Bool
}

public struct MemberGraphViewModel: MemberGraphViewModelProtocol {
    private let pieChartLabelSet: Observable<[String]>
    private let pieChartColorSet: Observable<[NSUIColor]>
    private let pieChartValueSet: Observable<[Double]>
    
    private let userSession: UserSession
    
    public let allMembers: Observable<[UserProfile]>
    public let pieChartData: Observable<PieChartData>
    public let pieChartUserHighlightX: Observable<Double>
    
    public init(
        allMembers: Observable<[UserProfile]>,
        userSession: UserSession
    ) {
        self.allMembers = allMembers
        self.userSession = userSession
        
        pieChartColorSet = allMembers.map { (allMembers) -> [NSUIColor] in
            return allMembers.map { UIColor(hex: $0.colorHex) as! NSUIColor }
        }
        
        pieChartLabelSet = allMembers.map { (allMembers) -> [String] in
            return allMembers.map { $0.username }
        }
        
        pieChartValueSet = allMembers.map { (allMembers) -> [Double] in
            return allMembers.map { Double($0.balance) }
        }
        
        pieChartData = Observable.combineLatest(pieChartValueSet,pieChartLabelSet, pieChartColorSet) { (pieChartValueSet,pieChartLabelSet, pieChartColorSet) -> PieChartData in
            let pieChartDataEntries = zip(pieChartValueSet, pieChartLabelSet).map { PieChartDataEntry(value: $0, label: $1) }
            let pieChartDataSet = PieChartDataSet(entries: pieChartDataEntries)
            pieChartDataSet.colors = pieChartColorSet
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .percent
            numberFormatter.maximumFractionDigits = 1
            numberFormatter.percentSymbol = "%"
            numberFormatter.multiplier = 1
            
            let valueLabelFont = UIFont.systemFont(ofSize: 11, weight: .semibold)
            
            let pieChartData = PieChartData(dataSet: pieChartDataSet)
            pieChartData.setValueFormatter(DefaultValueFormatter(formatter: numberFormatter))
            pieChartData.setValueFont(valueLabelFont)
            
            return pieChartData
        }
        
        pieChartUserHighlightX = Observable.combineLatest(allMembers, userSession.profile.asObservable()) { (allMembers, userProfile) -> Double in
            let userIndex = allMembers.firstIndex(of: userProfile)
            return Double(userIndex ?? 0)
        }
    }
    
    public func checkIsSelf(for userProfile: UserProfile) -> Bool {
        return userSession.profile.value == userProfile
    }
}
