import AppUI
import UIKit

public final class ProfileFooterView: UIView {
    // MARK: IBOutlet
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!

    // MARK: Properties
    private var groupName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }

    private var version: String {
        guard let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return v
    }

    // MARK: Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: Setup
    private func setup() {
        groupNameLabel.text = groupName
        versionLabel.text = "v\(version)"
    }
}

// MARK: Instance
extension ProfileFooterView: HasXib {
    public static func makeInstance() -> ProfileFooterView {
        let footerView = ProfileFooterView.loadXib(bundle: .module)
        return footerView
    }
}

