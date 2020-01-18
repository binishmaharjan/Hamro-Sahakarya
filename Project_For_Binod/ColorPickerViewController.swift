//
//  ColorPickerViewController.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/01/05.
//  Copyright © 2020 JEC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ColorPickerViewControllerFactory {
  func makeColorPickerViewController() -> ColorPickerViewController
}

final class ColorPickerViewController: UIViewController {
  
  @IBOutlet private weak var colorPalette: ColorPalette!
  @IBOutlet private weak var colorPreviewView: UIView!
  @IBOutlet private weak var colorPreviewLabel: UILabel!
  
  // MARK: Properties
  private var viewModel: ColorPaletteViewModelProtocol!
  private let disposeBag = DisposeBag()
  var colorSelected: ((String) -> Void)?
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    bind()
    bindAactionEvents()
  }
  
  // MARK: Methods
  private func setup() {
    colorPalette.onColorDidChange = colorDidChange(color:)
  }
  
  private func colorDidChange(color: UIColor) {
    viewModel.selectedColorInput.accept(color)
  }
  
  // MARK: IBActions
  @IBAction func selecButtonTapped(_ sender: Any) {
    viewModel.selectButtonTapped.onNext(())
  }
  
  @IBAction func cancelButtonTapped(_ sender: Any) {
    viewModel.cancelButtonTapped.onNext(())
  }
}

// MARK: Storyboard Instantiable
extension ColorPickerViewController: StoryboardInstantiable {
  
  static func makeInstance(viewModel: ColorPaletteViewModelProtocol) -> ColorPickerViewController {
    let viewController = loadFromStoryboard()
    viewController.viewModel = viewModel
    return viewController
  }
}

// MARK: Bind with viewmodel
extension ColorPickerViewController {
  
  private func bind() {
    viewModel.selectedColorInput
      .asObservable()
      .bind(to: colorPreviewView.rx.backgroundColor)
      .disposed(by: disposeBag)
    
    viewModel.selectedColorInput.asObservable()
      .map { $0.toHex() }
      .bind(to: colorPreviewLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func bindAactionEvents() {
    viewModel.event.bind { [weak self] (action) in
      guard let self = self else { return }
      
      switch action {
      case .selectButtonTapped:
        let selectedColor = self.viewModel.selectedColorInput.value
        guard let selectedColorHex = selectedColor.toHex() else { fatalError("Cannot Convert to Hex") }
        
        self.colorSelected?(selectedColorHex)
        self.dismiss(animated: true)
      case .cancelButtonTapped:
        self.dismiss(animated: true)
      }
    }.disposed(by: disposeBag)
  }
  
}
