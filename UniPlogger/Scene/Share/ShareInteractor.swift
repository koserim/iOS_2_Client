//
//  ShareInteractor.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/09/29.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShareBusinessLogic {
    func shareToInstagram(assetIdentifier: String)
}

protocol ShareDataStore {
  //var name: String { get set }
}

class ShareInteractor: ShareBusinessLogic, ShareDataStore {
    var presenter: SharePresentationLogic?
    var worker: ShareWorker?
  //var name: String = ""
    
    func shareToInstagram(assetIdentifier: String) {
        guard let url = URL(string: "instagram://library?LocalIdentifier=\(assetIdentifier)") else { return }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Instagram is not installed")
            }
        }
    }
}
