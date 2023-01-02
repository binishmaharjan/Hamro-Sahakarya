import AppUI
import UIKit

public final class LaunchRootView: UIView {
    // MARK: Properties
    private var viewModel: LaunchViewModel!
    
    // MARK: Methods
    static func makeInstance(viewModel: LaunchViewModel) -> LaunchRootView {
        let rootView = LaunchRootView.loadXib()
        rootView.viewModel = viewModel
        return rootView
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        loadUserSession()
    }
    
    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}

// MARK: Has Associated Xib File
extension LaunchRootView: HasXib { }
