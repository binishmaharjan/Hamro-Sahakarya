//
//  UIImageView+Extension.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/29.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import Nuke

// MARK: - Nuke
extension ImageLoadingOptions {
    
    static let `default` = ImageLoadingOptions(
        placeholder: nil,
        transition: .fadeIn(duration: 0.2),
        failureImage: nil
    )
}

extension UIImageView {
    
    /// 画像を非同期で読み込む
    /// request が nil なら即時 image に failureImage をセットして処理を終える
    /// すでに別の画像を読み込んでいる場合は読み込みがキャンセルされる
    func loadImage(with request: ImageRequest?, options: ImageLoadingOptions = .default, _ completion: ImageTask.Completion? = nil) {
        if let request = request {
            Nuke.loadImage(with: request, options: options, into: self, completion: completion)
        } else {
            // すでに画像を読み込んでいる可能性もあるのでキャンセルしておく
            Nuke.cancelRequest(for: self)
            image = options.failureImage
        }
    }
    
    /// URL 文字列の指す画像を非同期で読み込む
    /// 文字列が nil なら即時 image に failureImage をセットして処理を終える
    /// すでに別の画像を読み込んでいる場合は読み込みがキャンセルされる
    func loadImage(with url: URL?, options: ImageLoadingOptions = .default, _ completion: ImageTask.Completion? = nil) {
        
        let imageRequest: ImageRequest?
        if let url = url {
            imageRequest = ImageRequest(url: url)
        } else {
            imageRequest = nil
        }
        
        loadImage(with: imageRequest, options: options, completion)
    }
}

