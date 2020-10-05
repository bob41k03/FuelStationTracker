//
//  AppDelegate.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 28.09.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

