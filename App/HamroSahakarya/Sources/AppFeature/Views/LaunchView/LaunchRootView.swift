import AppUI
import UIKit

public final class LaunchRootView: UIView {
    //MARK: IBOutlets

    @IBOutlet private weak var logoImageView: UIImageView!

    // MARK: Properties
    private var viewModel: LaunchViewModel!
    
    // MARK: Methods
    static func makeInstance(viewModel: LaunchViewModel) -> LaunchRootView {
        let rootView = LaunchRootView.loadXib(bundle: Bundle.module)
        rootView.viewModel = viewModel
        return rootView
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        loadUserSession()
    }
    
    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}

// MARK: Setup
extension LaunchRootView {
    private func setup() {
        logoImageView.image = Asset.hamroSahakarya.image
    }
}

// MARK: Has Associated Xib File
extension LaunchRootView: HasXib { }
