//
//  ResetPasswordWorker.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/13.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ResetPasswordWorker {
    func validatePassword(text: String) -> Bool{
        return text.count >= 8 && text.count <= 20
    }

    func validatePasswordConfirm(password: String, passwordConfirm: String) -> Bool{
        return validatePassword(text: passwordConfirm) && password == passwordConfirm
    }
    
    
    func findPassword(
        request: ResetPassword.ResetPassword.Request,
        uid: String,
        token: String,
        completion: @escaping (ResetPassword.ResetPassword.Response) -> Void
    ) {
        AuthAPI.shared.resetPassword(password1: request.password1, password2: request.password2, uid: uid, token: token) { (response) in
            switch response{
            case let .success(value):
                if value.success, let data = value.data{
                    let response = ResetPassword.ResetPassword.Response(request: request, response: data)
                    completion(response)
                } else {
                    let response = ResetPassword.ResetPassword.Response(request: request, error: .server(value.message))
                    completion(response)
                }
            case let .failure(error):
                let response = ResetPassword.ResetPassword.Response(request: request, error: .error(error))
                completion(response)
            }
        }
    }
}
