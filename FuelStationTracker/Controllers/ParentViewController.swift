//
//  ParentViewController.swift
//  
//
//  Created by Ihor Vozhdai on 29.09.2020.
//

import Foundation
import XLPagerTabStrip


class ParentViewController: ButtonBarPagerTabStripViewController {

    // MARK: - Properties
    let purpleInspireColor = #colorLiteral(red: 0.1785928011, green: 0, blue: 1, alpha: 1)

    // MARK: - Functions
    override func viewDidLoad() {
        loadStyles()
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let fuelStations = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FuelStations")
    let details = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsStation")
    return [fuelStations, details]
    }

    func loadStyles() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 17)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 15
        settings.style.buttonBarRightContentInset = 15
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
                                        progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        oldCell?.label.textColor = .gray
        newCell?.label.textColor = self?.purpleInspireColor
        }
    }

}
