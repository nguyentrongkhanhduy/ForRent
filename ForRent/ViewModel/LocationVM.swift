//
//  LocationVM.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-01.
//

import Foundation
import Observation
import CoreLocation
import MapKit

@Observable
class LocationVM: NSObject, CLLocationManagerDelegate {
    static let shared = LocationVM()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var userLocation: CLLocationCoordinate2D?
    var isAuthorized: Bool = false
    var errorMessage = ""
    
    struct EquatableLocation: Equatable {
        let latitude: Double
        let longitude: Double
        
        init(from coordinate: CLLocationCoordinate2D) {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
    }
    
    var userLocationEquatable: EquatableLocation? {
        guard let location = userLocation else { return nil }
        return EquatableLocation(from: location)
    }
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocationPermisstion(completion: @escaping () -> Void) {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            errorMessage = "Please enable location permissions in Settings to improve accuracy."
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            errorMessage = ""
            locationManager.requestLocation()
        @unknown default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        isAuthorized = (
            status == .authorizedAlways || status == .authorizedWhenInUse
        )
        
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            print("Permission denied")
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        print("Failed to get location")
    }
    
    func fetchCityStateCountry(from location: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)

        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                completion("Unknown Location")
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""

                let formattedLocation = [city, state, country].filter { !$0.isEmpty }.joined(separator: ", ")

                DispatchQueue.main.async {
                    completion(formattedLocation)
                }
            } else {
                completion("Unknown Location")
            }
        }
    }
}
