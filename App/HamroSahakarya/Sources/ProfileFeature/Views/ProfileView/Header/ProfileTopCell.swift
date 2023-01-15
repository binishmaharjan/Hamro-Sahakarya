import RxSwift
import UIKit

final class ProfileTopCell: UITableViewCell {
    // MARK: IBOutlet
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: Methods
    func bind(viewModel: ProfileTopCellViewModel) {
        //Output
        viewModel.fullName
            .drive(userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.status
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.imageUrl.drive(onNext: { [weak self] (url) in
            self?.userImageView.loadImage(with: url)
        }).disposed(by: disposeBag)
    }
}
