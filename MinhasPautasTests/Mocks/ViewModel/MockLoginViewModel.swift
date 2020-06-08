//
//  MockLoginViewModel.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 04/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
@testable import MinhasPautas

// Used to test LoginViewController
class MockLoginViewModel: LoginViewModelProtocol {
    var sendCredentialsCalled = false

    func sendCredentials(email: String, password: String) {
        sendCredentialsCalled = true
    }
}
