//
//  ProgressHUD.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2019/11/15.
//  Copyright © 2019 JEC. All rights reserved.
//

import UIKit
import RxSwift

public protocol ProgressHUD {
    func startAnimation()
    func stopAnimation()
}

public typealias XibProgressHUDType = UIView & ProgressHUD

public final class XibProgressHUD: XibProgressHUDType {
    // MARK: IBOutlet
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var statusText: UILabel!

    // MARK: Properties
    public var isAnimating: Bool {
        return activityIndicator.isAnimating
    }

    // MARK: Instance
    public static func makeInstance() -> XibProgressHUD {
        let progressHud = XibProgressHUD.loadXib(bundle: .module)
        return progressHud
    }

    //MARK: Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.apply(types: [.cornerRadius(10)])
    }

    // MARK: Methods
    public func startAnimation() {
        activityIndicator.startAnimating()
    }

    public func stopAnimation() {
        activityIndicator.stopAnimating()
    }
}

extension XibProgressHUD: HasXib { }
