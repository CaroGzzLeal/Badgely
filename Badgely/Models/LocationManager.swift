//
//  LocationManager.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 07/10/25.
//  Code from: https://www.kodeco.com/20690666-location-notifications-with-unlocationnotificationtrigger

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
    
    let location = CLLocationCoordinate2D(latitude: 37.33182000, longitude: -122.03118000)
    lazy var storeRegion = makeStoreRegion()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    lazy var locationManager = makeLocationManager()
    
    private func makeLocationManager() -> CLLocationManager {
        let manager = CLLocationManager()
        manager.allowsBackgroundLocationUpdates = true
        
        return manager
    }
    
    private func makeStoreRegion() -> CLCircularRegion {
        
        let region = CLCircularRegion(
            center: location,
            radius: 2,
            identifier: UUID().uuidString)
        
        region.notifyOnEntry = true
        
        return region
    }
    
    func validateLocationAuthorizationStatus() {
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined, .denied, .restricted:
            print("Location Services Not Authorized")
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location Services Authorized")
            
        default:
            break
        }
    }
    
    func requestNotificationAuthorization() {
        
        let options: UNAuthorizationOptions = [.sound, .alert]
        
        notificationCenter
            .requestAuthorization(options: options) { [weak self] result, _ in
                print("Notification Auth Request result: \(result)")
                if result {
                    self?.registerNotification()
                }
            }
    }
    
    private func registerNotification() {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Welcome to Swifty TakeOut"
        notificationContent.body = "Your order will be ready shortly."
        notificationContent.sound = .default
        
        let trigger = UNLocationNotificationTrigger(
            region: storeRegion,
            repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        notificationCenter
            .add(request) { error in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            }
    }
}

extension LocationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("Received Notification")
        completionHandler()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Received Notification in Foreground")
        completionHandler(.sound)
    }
    
}



