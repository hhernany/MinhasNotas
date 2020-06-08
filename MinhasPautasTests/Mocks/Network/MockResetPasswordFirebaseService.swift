//
//  MockResetPasswordFirebaseService.swift
//  MinhasPautasTests
//
//  Created by Hugo Hernany on 03/06/20.
//  Copyright © 2020 Hugo Hernany. All rights reserved.
//

import Foundation
@testable import MinhasPautas

class MockResetPasswordFirebaseService: ResetPasswordFirebaseProtocol {
    var shoudReturnError = false
    
    func resetPassword(email: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        if shoudReturnError {
            completionHandler(false, NSError(domain: "Mock error returned", code: 500))
        } else {
            completionHandler(true, nil)
        }
    }
}
