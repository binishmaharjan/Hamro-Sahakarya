import Foundation
import PDFKit
import SwiftUI

public struct PDFViewer: UIViewRepresentable {
    public init(pdfDocument: PDFDocument?) {
        self.pdfDocument = pdfDocument
    }
    
    public var pdfDocument: PDFDocument?
    
    public func makeUIView(context: UIViewRepresentableContext<PDFViewer>) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        return pdfView
    }
    
    public func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFViewer>) {
        uiView.document = pdfDocument
    }
}
