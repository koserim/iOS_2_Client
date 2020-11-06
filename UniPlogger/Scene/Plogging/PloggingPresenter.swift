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
import CoreLocation
import MapKit

protocol PloggingPresentationLogic {
    func presentStartPlogging()
    func presentPausePlogging()
    func presentResumePlogging()
    func presentStopPlogging()

    func presentLocationService(response: Plogging.LocationAuth.Response)
    func presentUpdatePloggingLocation(response: Plogging.UpdatePloggingLocation.Response)
    
    //TrashCan
    func presentAddTrashCan(response: Plogging.AddTrashCan.Response)
    func presentAddConfirmTrashCan(response: Plogging.AddConfirmTrashCan.Response)
    func presentFetchTrashCan(response: Plogging.FetchTrashCan.Response)
}

class PloggingPresenter: PloggingPresentationLogic {
    weak var viewController: PloggingDisplayLogic?
    var locations: [Location] = []
    
    var speeds: [Double] = []
    var minSpeed = Double.greatestFiniteMagnitude
    var maxSpeed = 0.0
    
    var midSpeed: Double {
        return speeds.reduce(0, +) / Double(speeds.count)
    }
    func presentStartPlogging() {
        self.viewController?.displayStartPlogging()
    }
    
    func presentPausePlogging() {
        self.viewController?.displayPausePlogging()
    }
    
    func presentResumePlogging() {
        self.viewController?.displayResumePlogging()
    }
    
    func presentStopPlogging() {
        self.viewController?.displayStopPlogging()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return UserDefaults.standard.location
    }
    
    func presentLocationService(response: Plogging.LocationAuth.Response) {
      
        switch response.status{
        case .denied:
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            viewController?.displaySetting(message: "설정에서 위치 권한을 허용해주세요", url: url)    
        case .notDetermined, .restricted:
            guard let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") else { return }
            viewController?.displaySetting(message: "설정에서 위치 권한을 허용해주세요", url: url)
        case .authorizedWhenInUse, .authorizedAlways:
            viewController?.displayLocation(location: coordinate)
        default:
          break
        }
      
    }
    
    
    func presentUpdatePloggingLocation(response: Plogging.UpdatePloggingLocation.Response) {
        if let first = self.locations.last{
            let second = response.location
            self.locations.append(second)
            let polyLine = getPolyLine(first: first, second: second)
            if let region = mapRegion(){
                let viewModel = Plogging.UpdatePloggingLocation.ViewModel(
                    distance: FormatDisplay.distance(response.distance),
                    region: region,
                    polyLine: polyLine
                )
                viewController?.displayUpdatePloggingLocation(viewModel: viewModel)
            }
        }else{
            self.locations.append(response.location)
        }
    }
    
    func presentAddTrashCan(response: Plogging.AddTrashCan.Response) {
        let location = CLLocation(latitude: response.latitude, longitude: response.longitude)
        location.addressToPlace { (address) in
            let viewModel = Plogging.AddTrashCan.ViewModel(address: address)
            self.viewController?.displayAddTrashCan(viewModel: viewModel)
        }
    }
    
    func presentAddConfirmTrashCan(response: Plogging.AddConfirmTrashCan.Response) {
        let viewModel = Plogging.AddConfirmTrashCan.ViewModel(latitude: response.latitude, longitude: response.longitude)
        self.viewController?.displayAddConfirmTrashCan(viewModel: viewModel)
    }
    func presentFetchTrashCan(response: Plogging.FetchTrashCan.Response) {
        let viewModel = Plogging.FetchTrashCan.ViewModel(list: response.list)
        viewController?.displayFetchTrashCan(viewModel: viewModel)
    }
    
    //MARK: - Helper
    func getPolyLine(first: Location, second: Location) -> MultiColorPolyline{
        let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
        
        let distance = end.distance(from: start)
        let time = second.timestamp.timeIntervalSince(first.timestamp)
        let speed = time > 0 ? distance / time : 0
        
        self.speeds.append(speed)
        minSpeed = min(minSpeed, speed)
        maxSpeed = max(maxSpeed, speed)
        
        let coords = [start.coordinate, end.coordinate]
        let segment = MultiColorPolyline(coordinates: coords, count: 2)
        segment.color = segmentColor(
            speed: speed,
            midSpeed: midSpeed,
            slowestSpeed: minSpeed,
            fastestSpeed: maxSpeed
        )
        
        return segment
    }
    private func mapRegion() -> MKCoordinateRegion? {
      guard
        self.locations.count > 0
      else {
        return nil
      }
        
      let latitudes = locations.map { location -> Double in
        let location = location
        return location.latitude
      }
        
      let longitudes = locations.map { location -> Double in
        let location = location
        return location.longitude
      }
        
      let maxLat = latitudes.max()!
      let minLat = latitudes.min()!
      let maxLong = longitudes.max()!
      let minLong = longitudes.min()!
        
      let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                          longitude: (minLong + maxLong) / 2)
      let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                  longitudeDelta: (maxLong - minLong) * 1.3)
      return MKCoordinateRegion(center: center, span: span)
    }
    
    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
      enum BaseColors {
        static let r_red: CGFloat = 1
        static let r_green: CGFloat = 20 / 255
        static let r_blue: CGFloat = 44 / 255
        
        static let y_red: CGFloat = 1
        static let y_green: CGFloat = 215 / 255
        static let y_blue: CGFloat = 0
        
        static let g_red: CGFloat = 0
        static let g_green: CGFloat = 146 / 255
        static let g_blue: CGFloat = 78 / 255
      }
      
      let red, green, blue: CGFloat
      
      if speed < midSpeed {
        let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
        red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
        green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
        blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
      } else {
        let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
        red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
        green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
        blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
      }
      
      return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
