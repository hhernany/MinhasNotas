//
//  MockCreateScheduleViewModel.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 29/05/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
@testable import MinhasPautas

class MockCreateScheduleViewModel: CreateScheduleViewModelDelegate {
    var sendFormDataCalled = false
    
    required init(delegate: CreateScheduleViewControllerDelegate?, webservice: CreateScheduleWebServiceProtocol) {
        // TODO: If necessary ...
    }
    
    func sendFormData(formData: CreateScheduleModel) {
        sendFormDataCalled = true
    }
}
