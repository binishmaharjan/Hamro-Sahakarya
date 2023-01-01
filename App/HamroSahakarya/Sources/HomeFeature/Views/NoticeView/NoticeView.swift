import AppUI
import RxSwift
import UIKit

public final class NoticeView: UIView {
    //MARK: IBOutlet
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateCreatedLabel: UILabel!
    @IBOutlet private weak var adminLabel: UILabel!
    
    // MARK: Properties
    private var viewModel: NoticeViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    func bind() {
        //Output
        viewModel.message
            .asDriver()
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.admin
            .asDriver()
            .drive(adminLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dateCreated
            .asDriver()
            .drive(dateCreatedLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

//MARK: Xib Instantiable
extension NoticeView: HasXib {
    public static func makeInstance(viewModel: NoticeViewModelProtocol) -> NoticeView {
        let noticeView = NoticeView.loadXib()
        noticeView.viewModel = viewModel
        return noticeView
    }
}
