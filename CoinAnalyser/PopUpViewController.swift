//
//  PopUpViewController.swift
//  CoinAnalyser
//
//  Created by Siwa Sardjoemissier on 10/12/2017.
//  Copyright © 2017 Siwa Sardjoemissier. All rights reserved.
//

import UIKit

protocol PopUpViewControllerDelegate {
    func popUpViewControllerDidChangeMarker(_ popUpViewController: PopUpViewController)
}

class PopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var table: UITableView!

    
    var row: Int = 0
    
    public var delegate: PopUpViewControllerDelegate?

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let markerCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "markerCell")
        
        let markers = ["Name ASC", "Name DEC", "Dev. Activity ASC", "Dev. Activity DEC"]
        
        markerCell.textLabel?.text = markers[indexPath.row]

        return markerCell
    }

    @IBAction func comPlete(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        row = indexPath.row

        if row == 0 {
            AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.name < $1.name }
        }
    
        if row == 1 {
            AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.name > $1.name }
        }
        
        if row == 2 {
            AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.TwelveWeeksDev < $1.TwelveWeeksDev }
        }
        
        if row == 3 {
            AllCoinsViewController.coins = AllCoinsViewController.coins.sorted { $0.TwelveWeeksDev > $1.TwelveWeeksDev }
        }
        
        delegate?.popUpViewControllerDidChangeMarker(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.layer.borderWidth = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
