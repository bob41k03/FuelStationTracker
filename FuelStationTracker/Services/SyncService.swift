//
//  SyncService.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 04.10.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import Network
import FirebaseDatabase
import RealmSwift

class SyncService {

    //MARK: - Properties
    let monitor = NWPathMonitor()
    var items: Results<Order>!
    var ref = Database.database().reference()

    //MARK: - Functions
    func checkConnectionStatus() {
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            self.syncWithFirebase()
        }
    }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }

    // Sync Realm local DB with Firebase DB
    func syncWithFirebase() {
        DispatchQueue.main.async {
            let items = realm.objects(Order.self)
            for item in items {
                if item.orderId.isEmpty {
                    self.ref.child("Orders").child(item.orderId).setValue(["stationAddress": item.stationAddress,
                                                                           "stationName": item.stationName,
                                                                           "fuelQuantity": item.fuelQuantity,
                                                                           "fuelType": item.fuelType,
                                                                           "fuelCost": item.fuelCost])
                } else {
                    self.ref.child("Orders").child(item.orderId).updateChildValues(["stationAddress": item.stationAddress,
                                                                                    "stationName": item.stationName,
                                                                                    "fuelQuantity": item.fuelQuantity,
                                                                                    "fuelType": item.fuelType,
                                                                                    "fuelCost": item.fuelCost])
                }
            }
        }
    }
}

