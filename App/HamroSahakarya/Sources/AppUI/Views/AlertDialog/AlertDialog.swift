//
//  AlertDialog.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/02/01.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit

public final class AlertDialog: UIView {
    public enum AlertType {
        case notice
        case selection
    }

    // MARK: IBOutlets
    @IBOutlet private weak var dialogTitle: UILabel!
    @IBOutlet private weak var alertMessageLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!

    // MARK: Completion Handler
    public typealias CompletionHandler = () -> Void
    private var completionHandler: CompletionHandler?

    private func setupForAlertButton(for factory: AlertFactory) {
        dialogTitle.text = factory.title
        alertMessageLabel.text = factory.message

        if case .notice = factory.type {
            cancelButton.isHidden = true
        }
    }

    // MARK: IBAction
    @IBAction private func okButtonPressed(_ sender: Any) {
        guard superview != nil else {
            return
        }

        UIView.animate(withDuration: 0.3,
                       animations: hideView,
                       completion: removeViewWithCompletion(isCompleted:))
    }

    @IBAction private func cancelPressed(_ sender: Any) {
        guard superview != nil else {
            return
        }

        UIView.animate(withDuration: 0.3,
                       animations: hideView,
                       completion: removeView(isCompleted:))
    }

    // MARK: Methods
    private func hideView() {
        alpha = 0
    }

    private func removeView(isCompleted: Bool) {
        removeFromSuperview()
    }

    private func removeViewWithCompletion(isCompleted: Bool) {
        removeFromSuperview()
        completionHandler?()
    }

}

// MARK: Storyboard Instantiable
extension AlertDialog: HasXib {
    public static func makeInstance(factory: AlertFactory, handler: CompletionHandler? = nil ) -> AlertDialog {
        let alert = AlertDialog.loadXib(bundle: Bundle.module)
        alert.completionHandler = handler
        alert.setupForAlertButton(for: factory)

        return alert
    }
}


public enum AlertFactory {
    case noPhotoPermission
    case logoutConfirmation
    case changeAdminStatus(Bool)
    case removeMember

    public var title: String {
        switch self {

        case .noPhotoPermission:
            return "No Permission"
        case .logoutConfirmation, .removeMember:
            return "Confirmation"
        case .changeAdminStatus:
            return "Change Member Status"
        }
    }

    public var message: String {
        switch self {
        case .noPhotoPermission:
            return "You can grant access from the Settings app"
        case .logoutConfirmation, . removeMember:
            return "Are you sure."
        case .changeAdminStatus(let isUpgrade):
            return isUpgrade ? "Upgrade Status?" : "Degrade Status"
        }
    }

    public var type: AlertDialog.AlertType {
        switch self {

        case .noPhotoPermission:
            return .notice
        case .logoutConfirmation, .changeAdminStatus(_), .removeMember:
            return .selection
        }
    }
}
