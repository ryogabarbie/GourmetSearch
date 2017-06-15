//
//  LocationService.swift
//  GourmetSearch
//
//  Created by Ryoga on 2017/06/14.
//  Copyright © 2017年 Ryoga. All rights reserved.
//

import Foundation
import CoreLocation

public extension Notification.Name {
    public static let authDenied = Notification.Name("AuthDenied")
    public static let authRestricted = Notification.Name("AuthRestricted")
    public static let authorized = Notification.Name("Authorized")
    public static let didUpdateLocation = Notification.Name("DidUpdateLocation")
    public static let didFailLocation = Notification.Name("DidFailLocation")
}

public class LocationService: NSObject, CLLocationManagerDelegate {
    private let cllm = CLLocationManager()
    private let nc = NotificationCenter.default
    
    public var locationServiceDisabledAlert: UIAlertController {
        get {
            let alert = UIAlertController(title: "位置情報取得できません", message: "設定からプライバシー  → 位置情報画面を開いてGourmeSearchの位置情報の許可を「このAppの使用中のみ許可」を設定してください。", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
            )
            return alert
        }
    }
    
    public var locationServiceRestrictedAlert: UIAlertController {
        get {
            let alertView = UIAlertController(title: nil,
                                              message: "位置情報の取得に失敗しました",
                                              preferredStyle: .alert)
            alertView.addAction(
                UIAlertAction(title: "OK", style: .default, handler: nil)
            )
            return alertView
        }
    }
    
    public override init(){
        super.init()
        cllm.delegate = self
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            cllm.requestWhenInUseAuthorization()
        case .restricted:
            nc.post(name: .authRestricted, object: nil)
        case .denied:
            nc.post(name: .authDenied, object: nil)
        case .authorizedWhenInUse:
            break;
        default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        cllm.stopUpdatingLocation()
        if let location = locations.last {
            nc.post(name: .didUpdateLocation, object: self, userInfo: ["location": location])
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        nc.post(name: .didFailLocation, object: nil)
    }
    
    // MARK: - アプリケーションロジック
    public func startUpdationLocation(){
        cllm.startUpdatingLocation()
    }
}
