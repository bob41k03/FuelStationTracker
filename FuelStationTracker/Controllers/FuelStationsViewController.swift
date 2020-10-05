//
//  FuelStationsViewController.swift
//  FuelStationTracker
//
//  Created by Ihor Vozhdai on 29.09.2020.
//  Copyright © 2020 Ihor Vozhdai. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RealmSwift

class FuelStationsViewController: UIViewController, IndicatorInfoProvider {

    // MARK: - Outlets
    @IBOutlet var tableView: UITableView!

    // MARK: - Properties
    let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
    var items: Results<Order>!
    let syncService = SyncService()



    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Stations")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        syncService.checkConnectionStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = realm.objects(Order.self)
        tableView.reloadData()

    }

    // Navigation to NewStation controller
    private func navigateToAddNewStationController(currentOrder: Order? = nil) {
        let addNewStationVC = Storyboard.addNewStation.instanceOf(viewController: AddNewStation.self,
                                                                    identifier: "AddNewStation")!
        addNewStationVC.editingOrder = currentOrder
        navigationController?.pushViewController(addNewStationVC, animated: true)
        }
    }

    // MARK: - TableViewDelegate
extension FuelStationsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        tableView.tableHeaderView = header

        let colorIcon = #colorLiteral(red: 0.1785928011, green: 0, blue: 1, alpha: 1)
        let boldAddIcon = UIImage(systemName: "plus", withConfiguration: boldConfig)
        let addNewStationButton = UIButton(frame: CGRect(x: 0, y: 0, width: header.frame.size.width, height: header.frame.size.height))
        addNewStationButton.setTitleColor(colorIcon, for: .normal)
        addNewStationButton.setTitle("Add new station", for: .normal)
        addNewStationButton.setImage(boldAddIcon, for: .normal)
        addNewStationButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        header.addSubview(addNewStationButton)
        return header
    }

    @objc func buttonAction(sender: UIButton!) {
        navigateToAddNewStationController()
    }
}

    // MARK: - TableViewDataSource
extension FuelStationsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count != 0 {
           return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationsCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = "Station: \(item.stationName)"
        cell.detailTextLabel?.text = "Address: \(item.stationAddress)"

        let deleteButton = UIButton()
        let deleteIcon = UIImage(systemName: "trash.fill", withConfiguration: boldConfig)
        deleteButton.setImage(deleteIcon, for: .normal)
        deleteButton.frame = CGRect(x: self.view.frame.size.width-50, y: 10, width: 30, height: 30)
        deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)

        let editButton = UIButton()
        let editIcon = UIImage(systemName: "pencil.circle.fill", withConfiguration: boldConfig)
        editButton.setImage(editIcon, for: .normal)
        editButton.frame = CGRect(x: self.view.frame.size.width-90, y: 10, width: 30, height: 30)
        editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)

        cell.addSubview(deleteButton)
        cell.addSubview(editButton)

        return cell
    }

    @objc func deleteAction(sender: UIButton!) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        let editingRow = items[indexPath.row]
        try! realm.write {
            realm.delete(editingRow)
        }
        tableView.deleteRows(at: [indexPath], with: .left)
    }

    @objc func editAction(sender: UIButton!) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        let editingOrder = items[indexPath.row]
        navigateToAddNewStationController(currentOrder: editingOrder)
    }
}

