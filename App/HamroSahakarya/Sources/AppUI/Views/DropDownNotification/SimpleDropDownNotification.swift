import Core
import UIKit

public protocol DropDownNotification {
    func startDropDown()
}

public typealias DropDownNotificationType = DropDownNotification & BaseView

public final class SimpleDropDownNotification: DropDownNotificationType {

    private let bottomThreshold: CGFloat = 60.0
    private let dropDownWidth = UIScreen.main.bounds.size.width - 21.0
    private let dropDownHeight: CGFloat = 60.0
    private lazy var aboveThreshold: CGFloat = layoutMargins.top + 7.0

    private var dropDownLabel: UILabel? = nil
    public var text: String = "" {
        didSet {
            dropDownLabel?.text = text
        }
    }

    public var type: DropDownType = .normal {
        didSet {
            self.backgroundColor = type.backgroundColor
        }
    }

    public override func didInit() {
        super.didInit()

        frame = CGRect(x: 0, y: 0, width: dropDownWidth, height: dropDownHeight)
        clipsToBounds = true
        apply(types: [.cornerRadius(5.0)])

        let label = UILabel()
        dropDownLabel = label
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Drop Down Notification"
        label.width = width
        label.textAlignment = .center
        label.height = dropDownHeight
        label.center = self.o
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)

        isUserInteractionEnabled = true

        center.x = UIScreen.main.bounds.size.width / 2.0
        bottom = 0

        setupGesture()
    }
}

// MARK: Animations
extension SimpleDropDownNotification {
    /// Start the Drop Down Notification Animation
    public func startDropDown() {
        dropDownAnimation()
        dropUpAnimation()
    }

    private func dropDownAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: { [weak self] in
            guard let self = self else { return }
            self.y = self.aboveThreshold
        })
    }

    private func dropUpAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: { [weak self] in
                guard let self = self else { return }

                self.y = -(self.dropDownHeight + 7.0)

            }){ [weak self] _ in
                guard let self = self else { return }
                self.removeFromSuperview()
            }
        }
    }
}

// MARK: Gesture Recognization
extension SimpleDropDownNotification {

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragGesture(_:)))
        addGestureRecognizer(panGesture)
    }

    // MARK: Tap Gesture (Will Not Be Implemented)
    @objc private func viewTapped(_ sender: UITapGestureRecognizer){

    }

    // MARK: Pan Gesture
    @objc private func dragGesture(_ sender: UIPanGestureRecognizer) {

        let point = sender.translation(in: self)
        var movedPoint = CGPoint(x: center.x, y: sender.view!.center.y + point.y)

        if movedPoint.y > bottomThreshold {
            movedPoint.y = bottomThreshold
        }

        if sender.state == .ended {
            if movedPoint.y < aboveThreshold + dropDownWidth / 2.0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    guard let self = self else { return }
                    self.bottom = 0.0
                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.removeFromSuperview()
                })

                return
            }

            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                movedPoint.y = self.aboveThreshold + self.dropDownHeight / 2.0
            })

            sender.view!.center = movedPoint
            sender.setTranslation(.zero, in: self)
        }
    }

    @objc private func setupPanGesture(swipeGesture: [UISwipeGestureRecognizer]) {
        let panGesture = UIPanGestureRecognizer.init(target: self, action:#selector(dragGesture(_ :)))
        self.addGestureRecognizer(panGesture)
    }
}
