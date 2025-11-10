//
//  LocationManager.swift
//  Badgely
//
//  Created by Carolina Nicole Gonzalez Leal on 07/10/25.
//  Code starting point from: https://www.kodeco.com/20690666-location-notifications-with-unlocationnotificationtrigger

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // Lista completa de lugares cargados desde el JSON
    @Published var places: [Place] = []
    
    @Published var nearestFive: [Place] = []
    
    // Mantiene las regiones ya notificadas
    private var notifiedRegions: Set<String> = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        notificationCenter.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    //Cargar lugares y empezar el monitoreo dinámico
    func loadPlacesAndRegisterRegions(for city: String = "Monterrey") {
        //places = Bundle.main.decode("places2.json")
        loadPlaces(for: city)
        validateLocationAuthorizationStatus()
        requestNotificationAuthorization()
        
        // Iniciar monitoreo de cambios significativos
        startMonitoringSignificantChanges()
    }
    
    //Load places para city especifica
    func loadPlaces(for city: String) {
        let fileName = jsonFileName(for: city)
        
        //load json de la city, fallback to mty
        if Bundle.main.url(forResource: fileName, withExtension: nil) != nil {
            places = Bundle.main.decode(fileName)
            print("LocationManager: Loaded \(places.count) places for \(city)")
        } else {
            // Fallback to Monterrey if city JSON not found
            print("LocationManager: No JSON for \(city), using default Monterrey")
            places = Bundle.main.decode("places2.json")
        }
        
        //Re-evaluate closest regions with new places
        if let currentLocation = locationManager.location {
            evaluateClosestRegions(from: currentLocation)
        }
    }
    
    //Get JSON filename for city
    private func jsonFileName(for city: String) -> String {
        switch city {
        case "Monterrey":
            return "places2.json"
        case "Guadalajara":
            return "places_guadalajara.json"
        case "Ciudad de México":
            return "places_mexicocity.json"
        default:
            return "places2.json"
        }
    }

    //Pedir permisos de ubicación
    func validateLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location Authorized")
        case .denied, .restricted:
            print("Location Denied")
        @unknown default:
            break
        }
    }
    
    // Pedir permisos de notificación
    func requestNotificationAuthorization() {
        //notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            if granted {
                print("Notifications Authorized")
            } else {
                print("Notifications Denied")
            }
        }
    }

    //Iniciar monitoreo de cambios significativos
    private func startMonitoringSignificantChanges() {
        //print("Iniciando monitoreo de cambios significativos de ubicación...")
        locationManager.startMonitoringSignificantLocationChanges()
    }

    //Evaluar y actualizar las regiones más cercanas
    private func evaluateClosestRegions(from location: CLLocation) {
        // Ordenar los lugares por distancia al usuario
        let sortedPlaces = places.sorted {
            let loc1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let loc2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
            return loc1.distance(from: location) < loc2.distance(from: location)
        }
        
        //tmar las 20 más cercanas
        let closestPlaces = Array(sortedPlaces.prefix(20))
        nearestFive = Array(sortedPlaces.prefix(5))
        
        //detener monitoreo anterior
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        
        // Iniciar monitoreo solo para las 20 más cercanas
        for place in closestPlaces {
            let center = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let region = CLCircularRegion(center: center, radius: 50, identifier: place.name)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
        }
        
        //print("Actualizadas las regiones más cercanas. Ahora se monitorean \(closestPlaces.count) lugares.")
    }

    //Enviar notificación
    private func sendArrivalNotification(for placeName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Llegaste a \(placeName)"
        content.body = "¡Bienvenido a \(placeName)!"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error enviando notificación: \(error)")
            } else {
                print("Notificación enviada para \(placeName)")
            }
        }
    }
}

//CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        validateLocationAuthorizationStatus()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        //print("Nueva ubicación significativa: \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
        evaluateClosestRegions(from: latestLocation)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }

        if !notifiedRegions.contains(circularRegion.identifier) {
            notifiedRegions.insert(circularRegion.identifier)
            sendArrivalNotification(for: circularRegion.identifier)
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }
        notifiedRegions.remove(circularRegion.identifier)

        if let currentLocation = manager.location {
            //print("Saliste de \(circularRegion.identifier) en lat: \(currentLocation.coordinate.latitude), lon: \(currentLocation.coordinate.longitude)")
            // Re-evaluar regiones cercanas al salir de una zona
            evaluateClosestRegions(from: currentLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Error al monitorear región: \(error.localizedDescription)")
    }
}

//UNUserNotificationCenterDelegate
extension LocationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

