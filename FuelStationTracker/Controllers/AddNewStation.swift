//
//  AddNewStation.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 29.09.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddNewStation: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stationNameTextField: UITextField!
    @IBOutlet weak var fuelQuantityTextField: UITextField!
    @IBOutlet weak var fuelTypeTextField: UITextField!
    @IBOutlet weak var fuelCostTextField: UITextField!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    var editingOrder: Order?

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationEnabled()
        saveButton.isEnabled = false
        stationNameTextField.addTarget(self, action: #selector(validationTextField), for: .editingChanged)
        fuelQuantityTextField.addTarget(self, action: #selector(validationTextField), for: .editingChanged)
        fuelTypeTextField.addTarget(self, action: #selector(validationTextField), for: .editingChanged)
        fuelCostTextField.addTarget(self, action: #selector(validationTextField), for: .editingChanged)

        isEditingOrder()
    }

    // Validation for text fields while add new station
    @objc func validationTextField(_ textField: UITextField) {
        if addressLabel.text != nil &&
        stationNameTextField.text != "" &&
        fuelQuantityTextField.text != "" &&
        fuelTypeTextField.text != "" &&
        fuelCostTextField.text != ""
        {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    // Pass data of editing order
    func isEditingOrder() {
        guard let order = editingOrder else { return }
        addressLabel.text = order.stationAddress
        stationNameTextField.text = order.stationName
        fuelQuantityTextField.text = "\(String(describing: order.fuelQuantity))"
        fuelTypeTextField.text = order.fuelType
        fuelCostTextField.text = "\(String(describing: order.fuelCost))"
    }

    // Work with Map
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAutorizationStatus()
        } else {
            showAlert(title: "Geolocation is not enabled",
                      message: "To use map, you must enable geolocation in Location Services settings",
                      url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }

    func showAlert(title: String, message: String?, url: URL?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { alert in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func setupLocationManager() {
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkAutorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            startTackingUserLocation()
            break
        case .denied:
            showAlert(title: "Allow app to access your location while you are using the app?",
                      message: "Your current location will displayed on the map.",
                      url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }

    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }


    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    // create object and save new order to local DB
    @IBAction func saveNewStation(_ sender: Any) {

        let newOrder = Order()
        newOrder.stationAddress = addressLabel.text!
        newOrder.stationName = stationNameTextField.text!
        newOrder.fuelQuantity = NumberFormatter().number(from: fuelQuantityTextField.text!)!.doubleValue
        newOrder.fuelType = fuelTypeTextField.text!
        newOrder.fuelCost = NumberFormatter().number(from: fuelCostTextField.text!)!.doubleValue

        try! realm.write {
            realm.add(newOrder, update: .all)
        }

        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        }
    }


extension AddNewStation : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorizationStatus()
    }
}

extension AddNewStation : MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()

        guard let previousLocation = self.previousLocation else { return }

        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center

        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }

            if let _ = error {
                return
            }

            guard let placemark = placemarks?.first else {
                return
            }

            let city = placemark.locality ?? ""
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

            DispatchQueue.main.async {
                self.addressLabel.text = "\(city) \(streetNumber) \(streetName)"
            }
        }
    }
}
