//
//  PloggingPresenter.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/27.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PloggingPresentationLogic {
    func presentDoing()
    func presentPause()
}

class PloggingPresenter: PloggingPresentationLogic {
    weak var viewController: PloggingDisplayLogic?
    func presentDoing() {
        viewController?.displayStart()
    }
    func presentPause() {
        viewController?.displayStart()
    }
}
