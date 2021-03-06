//
//  PloggingAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/12.
//  Copyright © 2020 손병근. All rights reserved.
//

import Moya
import RxSwift

final class PloggingAPI{
    typealias Response<T: Codable> = BaseResponse<T>
    
    let disposeBag = DisposeBag()
    
    static let shared = PloggingAPI()
    private let provider = MoyaProvider<PloggingAPITarget>(
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func createTrashCan(latitude: Double, longitude: Double, address: String, completionHandler: @escaping (Result<Response<TrashCan>, Error>) -> Void){
        provider.rx.request(.createTrash(latitude: latitude, longitude: longitude, address: address))
            .filterSuccessfulStatusCodes()
            .map(Response<TrashCan>.self)
            .subscribe {
                completionHandler(.success($0))
            } onError: {
              completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func fetchTrashList(completionHandler: @escaping (Result<Response<[TrashCan]>, Error>)-> Void){
        provider.rx.request(.fetchTrashList)
            .filterSuccessfulStatusCodes()
            .map(Response<[TrashCan]>.self)
            .subscribe(onSuccess: {
                completionHandler(.success($0))
            }, onError: { completionHandler(.failure($0)) })
            .disposed(by: disposeBag)
    }
    
    func deleteTrashCan(id: Int64, completionHandler: @escaping (Result<Response<TrashCan>, Error>) -> Void) {
        provider.rx.request(.deleteTrashCan(id: id))
            .filterSuccessfulStatusCodes()
            .map(Response<TrashCan>.self)
            .subscribe {
                completionHandler(.success($0))
            } onError: {
                completionHandler(.failure($0))
            }.disposed(by: self.disposeBag)
    }
    
    func uploadRecord(uid: Int, title: String, distance: Double, time: Int, image: UIImage, completionHandler: @escaping(Result<Response<Feed>, Error>) -> Void) {
        provider.rx.request(.uploadRecord(uid: uid, title: title, distance: distance, time: time, image: image))
            .filterSuccessfulStatusCodes()
            .map(Response<Feed>.self)
            .subscribe {
                completionHandler(.success($0))
            } onError: {
                print($0.localizedDescription)
                completionHandler(.failure($0))
            }.disposed(by: self.disposeBag)
    }
    
    
}
