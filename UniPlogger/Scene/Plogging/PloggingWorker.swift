//
//  PloggingWorker.swift
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
import CoreLocation

protocol PloggingWorkerDelegate{
    func updateRoute(distance: Measurement<UnitLength>, location: Location)
}

class PloggingWorker: NSObject {
    static var trashCanList: [TrashCan] = [
        .init(latitude: 37.4972632, longitude: 126.8450178, isRemoved: false),
        .init(latitude: 37.5015682, longitude: 126.844351, isRemoved: false),
        .init(latitude: 37.4944, longitude: 126.8423623, isRemoved: false),
        .init(latitude: 37.4961687, longitude: 126.8426605, isRemoved: false)
    ]
    
    private let locationManager = LocationManager.shared.locationManager
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    var delegate: PloggingWorkerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: - Helper
    func resetLocationData(){
        distance = Measurement(value: 0, unit: UnitLength.meters)
    }
    func startRun(){
        resetLocationData()
        startUpdateLocation()
    }
    func stopRun(){
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdateLocation(){
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 5
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
}

extension PloggingWorker: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            //Todo: 위치권한 사용하기
            print("authorized")
            startUpdateLocation()
        case .denied:
            print("denied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            print("else")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations{
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            print("horizontalAccuracy: \(newLocation.horizontalAccuracy)")
            print("howRecent: \(abs(howRecent))")
            
            guard abs(howRecent) < 10 else { continue }
            if let lastLocation = self.locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let location = Location(
                    latitude: newLocation.coordinate.latitude,
                    longitude: newLocation.coordinate.longitude,
                    timestamp: newLocation.timestamp)
                
                self.delegate?.updateRoute(distance: distance, location: location)
            }
            locationList.append(newLocation)
        }
    }
    
}
