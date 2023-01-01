import Core
import UIKit

public final class MembersCell: UITableViewCell {
    // MARK: IBOutlet
    @IBOutlet private weak var memberImageView: UIImageView!
    @IBOutlet private weak var memberNameLabel: UILabel!
    @IBOutlet private weak var memberStatusLabel: UILabel!

    // MARK: LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        memberImageView.layer.cornerRadius = memberImageView.width / 2
        memberImageView.clipsToBounds = true
    }

    // MARK: Methods
    public func bind(viewModel: MemberCellViewModel) {
        memberNameLabel.text = viewModel.fullName
        memberStatusLabel.text = viewModel.status
        memberImageView.loadImage(with: viewModel.imageUrl)
    }

    public func makeAllCell() {
        memberNameLabel.text = "All"
        memberStatusLabel.text = "Status: -"
        memberImageView.image = UIImage(named: "hamro_sahakarya")
    }
}

// MARK: ViewModel
public protocol MemberCellViewModel {
    var imageUrl: URL? { get }
    var fullName: String { get }
    var status: String { get }
}

public struct DefaultMemberCellViewModel: MemberCellViewModel {
    private let profile: UserProfile

    public var imageUrl: URL? {
        let imageString = profile.iconUrl ?? ""
        return URL(string: imageString)
    }

    public var fullName: String {
        return profile.username
    }

    public var status: String {
        return "Status: \(profile.status .rawValue)"
    }

    public init(profile: UserProfile) {
        self.profile = profile
    }
}
