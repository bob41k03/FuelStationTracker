//
//  FuelStationModel.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 01.10.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import Foundation
import RealmSwift

class Order: Object {
    @objc dynamic var orderId: String = UUID().uuidString
    @objc dynamic var stationAddress: String = ""
    @objc dynamic var stationName: String = ""
    @objc dynamic var fuelQuantity: Double = 0.0
    @objc dynamic var fuelType: String = ""
    @objc dynamic var fuelCost: Double = 0.0

    override static func primaryKey() -> String? {
        return "orderId"
    }
}
