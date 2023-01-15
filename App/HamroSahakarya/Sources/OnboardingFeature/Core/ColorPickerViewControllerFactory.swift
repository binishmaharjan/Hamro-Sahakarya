import Foundation

public protocol ColorPickerViewControllerFactory {
  func makeColorPickerViewController() -> ColorPickerViewController
}
