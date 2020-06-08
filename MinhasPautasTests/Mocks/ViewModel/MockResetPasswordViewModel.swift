//
//  MockResetPasswordViewModel.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
@testable import MinhasPautas

// Used to test ResetPasswordViewController
class MockResetPasswordViewModel: ResetPasswordViewModelProtocol {
    var sendCredentialsCalled = false

    func sendCredentials(email: String) {
        sendCredentialsCalled = true
    }
}
