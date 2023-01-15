import Core
import UIKit

public class MemberWithLoanCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        memberImageView.layer.cornerRadius = memberImageView.width / 2
        memberImageView.clipsToBounds = true
    }
    
    public func bind(viewModel: MemberWithLoanViewModelProtocol) {
        memberImageView.loadImage(with: viewModel.imageUrl)
        memberNameLabel.text = viewModel.fullName
        loanAmountLabel.text = viewModel.loanAmount
    }
}

// MARK: ViewModel
public protocol MemberWithLoanViewModelProtocol {
  var imageUrl: URL? { get }
  var fullName: String { get }
  var loanAmount: String { get }
}

public struct MemberWithLoanCellViewModel: MemberWithLoanViewModelProtocol {
  private let profile: UserProfile
   
    public var imageUrl: URL? {
     let imageString = profile.iconUrl ?? ""
     return URL(string: imageString)
   }
   
    public var fullName: String {
     return profile.username
   }
   
    public var loanAmount: String {
     return "Loan Taken: \(profile.loanTaken)"
   }
   
    public init(profile: UserProfile) {
     self.profile = profile
   }
}
