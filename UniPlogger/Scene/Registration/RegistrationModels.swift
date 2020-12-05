//
//  RegistrationModels.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/05.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Registration {
    // MARK: Use cases
    
    enum UseCase {
        
    }
    
    enum ValidateAccount{
      struct Request{
        var account: String
      }
      struct Response{
        var isValid: Bool
      }
    }
    
    enum ValidatePassword{
      struct Request{
        var password: String
      }
      struct Response{
        var isValid: Bool
      }
    }
    
    enum ValidatePasswordConfirm{
      struct Request{
        var password: String
      }
      struct Response{
        var isValid: Bool
      }
    }
    
    
    struct ValidationViewModel{
      var isValid: Bool
    }
}
