//
//  PloggingRecordRouter.swift
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

protocol PloggingRecordRoutingLogic {
    func routeToShare()
    func routeToCamera()
    func passDataToQuest(ploggingData: PloggingData?)
}

protocol PloggingRecordDataPassing {
  var dataStore: PloggingRecordDataStore? { get }
}

class PloggingRecordRouter: NSObject, PloggingRecordRoutingLogic, PloggingRecordDataPassing {
  weak var viewController: PloggingRecordViewController?
  var dataStore: PloggingRecordDataStore?
  
  // MARK: Routing
    func routeToShare() {
        let destinationVC = ShareViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToShare(source: dataStore!, destination: &destinationDS)
        navigateToShare(source: viewController!, destination: destinationVC)
    }
    
    func routeToCamera() {
        let destinationVC = CameraViewController()
        passDataToCamera(source: dataStore!, destination: destinationVC)
        navigateToCamera(source: viewController!, destination: destinationVC)
    }
    
    func passDataToQuest(ploggingData: PloggingData?) {
        guard let data = ploggingData,
              let tabBarVC = viewController?.presentingViewController as? MainTabBarController,
              let questNav = (tabBarVC.viewControllers?[1] as? QuestNavigationController),
              let questVC = questNav.viewControllers.first as? QuestViewController
        else {
            return
        }
        
        questVC.router?.dataStore.questManager.finish(plogging: data)
    }
    
    func navigateToShare(source: PloggingRecordViewController, destination: ShareViewController){
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToCamera(source: PloggingRecordViewController, destination: CameraViewController){
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func passDataToShare(source: PloggingRecordDataStore, destination: inout ShareDataStore){
        let selectedItems = viewController?.selectedItems ?? []
        let selectPloggingItems = selectedItems.map { PloggingItemType.allCases[$0] }
        
        destination.ploggingData = source.ploggingData
        
        destination.ploggingData?.items = selectPloggingItems
        destination.image = viewController?.capturedImage
        
        passDataToQuest(ploggingData: destination.ploggingData)
    }
    
    func passDataToCamera(source: PloggingRecordDataStore, destination: CameraViewController) {
        let selectedItems = viewController?.selectedItems ?? []
        let selectPloggingItems = selectedItems.map { PloggingItemType.allCases[$0] }
        
        destination.ploggingData = source.ploggingData
        destination.ploggingData?.items = selectPloggingItems
    }
}
