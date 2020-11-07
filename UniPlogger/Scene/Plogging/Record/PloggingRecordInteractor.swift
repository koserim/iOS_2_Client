//
//  PloggingRecordInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/10/22.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PloggingRecordBusinessLogic {
    func fetchRecord()
}

protocol PloggingRecordDataStore {
    var distance: Measurement<UnitLength>? { get set }
    var seconds: Int? { get set }
    var minutes: Int? { get set }
}

class PloggingRecordInteractor: PloggingRecordBusinessLogic, PloggingRecordDataStore {
    var distance: Measurement<UnitLength>?
    var seconds: Int?
    var minutes: Int?
    
    var presenter: PloggingRecordPresentationLogic?
    var worker: PloggingRecordWorker?
  
    func fetchRecord() {
        guard let distance = self.distance,
              let seconds = self.seconds,
              let minutes = self.minutes
        else { return }
        let response = PloggingRecord.FetchRecord.Response(distance: distance, seconds: seconds, minutes: minutes)
        self.presenter?.presentFetchRecord(response: response)
    }
}