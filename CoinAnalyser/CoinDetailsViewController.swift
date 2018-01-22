//
//  ViewController.swift
//  CoinMockup
//
//  Created by Siwa Sardjoemissier on 08/01/2018.
//  Copyright © 2018 Siwa Sardjoemissier. All rights reserved.
//

import UIKit
import SwiftChart

class CoinDetailsViewController: UIViewController {
    var coin: Coin!
    
    var name: String = "name"
    
    @IBOutlet weak var volumeChart: Chart!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var devActivity: UILabel!
    @IBAction func watchListPressed(_ sender: Any) {
        
    }
    @IBAction func cmcPressed(_ sender: Any) {
        
        let URL = "https://coinmarketcap.com/currencies/" + coin.name
        
        UIApplication.shared.openURL(NSURL(string: URL)! as URL)
    }
    
    @IBAction func googlePressed(_ sender: Any) {
        
        let URL = "https://www.google.nl/search?q=" + coin.name
        
        
        UIApplication.shared.openURL(NSURL(string: URL)! as URL)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(coin)
        nameLabel.text = coin.name.firstUppercased
        if coin.TwelveWeeksDev < 0 {
            devActivity.text = String(format: "%.2f", coin.TwelveWeeksDev) + "%"
            devActivity.textColor = UIColor.red
        }
        else {
            devActivity.text = "+" + String(format: "%.2f", coin.TwelveWeeksDev) + "%"
            devActivity.textColor = UIColor.green
        }

        let series = ChartSeries(coin.commitArray)
        series.color = ChartColors.greenColor()
        chart.xLabels = [52, 39, 26, 13, 0]
        chart.xLabelsFormatter = { "w" + String(Int(round($1))) }
        chart.add(series)
        
        let volumeseries = ChartSeries(coin.volumeArray as! [Float])
        volumeseries.color = ChartColors.redColor()
        volumeChart.showXLabelsAndGrid = false
        volumeChart.showYLabelsAndGrid = false
        volumeChart.add(volumeseries)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

