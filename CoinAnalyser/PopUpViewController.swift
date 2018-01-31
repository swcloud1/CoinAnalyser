//
//  PopUpViewController.swift
//  CoinAnalyser
//
//  Created by Siwa Sardjoemissier on 10/12/2017.
//  Copyright © 2017 Siwa Sardjoemissier. All rights reserved.
//

import UIKit

// allow viewcontroller to reload table on another viewcontroller
protocol PopUpViewControllerDelegate {
    func popUpViewControllerDidChangeMarker(_ popUpViewController: PopUpViewController)
}

class PopUpViewController: UIViewController {

    
    public var delegate: PopUpViewControllerDelegate?

    // return to the previous view when a touch is registered outside the view
    @IBAction func comPlete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // sort the AllCoinsView
    @IBAction func nameAscPressed(_ sender: Any) {
        AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.name < $1.name }
        delegate?.popUpViewControllerDidChangeMarker(self)
    }
    @IBAction func nameDecPressed(_ sender: Any) {
        AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.name > $1.name }
        delegate?.popUpViewControllerDidChangeMarker(self)
    }
    @IBAction func devAscPressed(_ sender: Any) {
        AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.TwelveWeeksDev < $1.TwelveWeeksDev }
        delegate?.popUpViewControllerDidChangeMarker(self)
    }
    @IBAction func devDecPressed(_ sender: Any) {
        AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.TwelveWeeksDev > $1.TwelveWeeksDev }
        delegate?.popUpViewControllerDidChangeMarker(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
