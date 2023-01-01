import UIKit

public final class LogViewCell: UITableViewCell {
    // MARK: IBOutlet
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Properties
    private var viewModel: LogCellViewModel!
    
    // MARK: Methods
    public func bind(viewModel: LogCellViewModel) {
        self.viewModel = viewModel
        dateLabel.text = viewModel.dateCreated
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
