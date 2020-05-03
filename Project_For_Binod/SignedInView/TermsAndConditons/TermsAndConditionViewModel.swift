//
//  TermsAndConditionViewModel.swift
//  Project_For_Binod
//
//  Created by Maharjan Binish on 2020/05/03.
//  Copyright © 2020 JEC. All rights reserved.
//

import Foundation
import PDFKit

protocol TermsAndConditionViewModelProtocol {
    
    var pdfDocument: PDFDocument { get }
}

struct TermsAndConditionViewModel: TermsAndConditionViewModelProtocol {
    
    private let fileName = "terms_and_conditions"
    private let fileType = "pdf"
    
    let pdfDocument: PDFDocument
    
    init() {
        let path = Bundle.main.path(forResource: fileName, ofType: fileType)!
        pdfDocument = PDFDocument(url: URL(fileURLWithPath: path))!
    }
}
