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
    func fetchRecord()
    func shareToInstagram(assetIdentifier: String)
    var image: UIImage? { get set }
}

protocol ShareDataStore {
    var ploggingData: PloggingData? { get set }
    var image: UIImage? { get set }
}

class ShareInteractor: ShareBusinessLogic, ShareDataStore {
    var ploggingData: PloggingData?
    var image: UIImage?
    
    var presenter: SharePresentationLogic?
    var worker: ShareWorker = ShareWorker()
    
    func fetchRecord() {
        guard let ploggingData = self.ploggingData,
              let image = self.image
        else { return }
        UPLoader.shared.show()
        worker.uploadPloggingRecord(data: ploggingData, image: image) { [weak self] response in
            self?.presenter?.presentFetchRecord(response: response)
        }
    }
    
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
