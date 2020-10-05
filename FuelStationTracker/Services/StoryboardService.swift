//
//  StoryboardManager.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 29.09.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import UIKit

enum Storyboard: String {

    case addNewStation = "AddNewStation"

    var instance: UIStoryboard {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        return storyboard
    }

    func instanceOf<T: UIViewController>(viewController: T.Type,
                                         identifier viewControllerIdentifier: String? = nil) -> T? {
        if let identifier = viewControllerIdentifier {
            return instance.instantiateViewController(withIdentifier: identifier) as? T
        }
        return instance.instantiateInitialViewController() as? T
    }
}
