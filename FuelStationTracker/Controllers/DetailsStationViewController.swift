//
//  DetailsStationViewController.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 29.09.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class DetailsStationViewController: UIViewController, IndicatorInfoProvider {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var items: Results<Order>!

    // MARK: - Functions
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Details")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = realm.objects(Order.self)
        tableView.reloadData()
    }
}

    // MARK: - TableViewDelegate, TableViewDataSource
extension DetailsStationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
           return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
        let item = items[indexPath.row]
        cell.addressLabel.text = "Address: \(item.stationAddress)"
        cell.stationNameLabel.text = "Station Name: \(item.stationName)"
        cell.fuelQuantityLabel.text = "Fuel Quantity: \(String(item.fuelQuantity))"
        cell.fuelTypeLabel.text = "Fuel Type: \(item.fuelType)"
        cell.fuelCostLabel.text = "Fuel Cost: \(String(item.fuelCost))"
        return cell
    }


}
