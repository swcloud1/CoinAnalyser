//
//  ViewController.swift
//  CoinAnalyser
//
//  Created by Siwa Sardjoemissier on 08/01/2018.
//  Copyright © 2018 Siwa Sardjoemissier. All rights reserved.
//

import UIKit
import SwiftChart

class CoinDetailsViewController: UIViewController {
    
    // This coin object will hold the coin-info given by AllCoinsView or MyCoinsView
    var coin: Coin!
    
    @IBOutlet weak var volumeChart: Chart!
    @IBOutlet weak var trendChart: Chart!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var devActivity: UILabel!
    @IBOutlet weak var lastvolume24h: UILabel!
    @IBOutlet weak var trendSwitch: UISwitch!
    @IBOutlet weak var volSwitch: UISwitch!
    @IBOutlet weak var devSwitch: UISwitch!
    
    
    @IBAction func blueTriggered(_ sender: Any) {
        
        let onState = trendSwitch.isOn
        if onState {
            trendChart.isHidden = false
        }
        else {
            trendChart.isHidden = true
        }
    }
    
    @IBAction func redTriggered(_ sender: Any) {
        let onState = volSwitch.isOn
        if onState {
            volumeChart.isHidden = false
        }
        else {
            volumeChart.isHidden = true
        }
    }
    
    @IBAction func greenTriggered(_ sender: Any) {
        let onState = devSwitch.isOn
        if onState {
            chart.isHidden = false
        }
        else {
            chart.isHidden = true
        }
    }
    
    
    // Allow the user to share the name and URL of a single coin
    @IBAction func sharePressed(_ sender: Any) {
        
        // set share content
        var coinNames = "Check Out This Coin: \n"
        coinNames += "\n" + coin.name.firstUppercased + ": \n" + "http://coinmarketcap.com/currencies/" + coin.name + "\n"
        
        // create sharing window
        let activityVC = UIActivityViewController(activityItems: [coinNames], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    // Allow the user to add a coin to their WatchList
    @IBAction func watchListPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add \(coin.name.firstUppercased) to Your Watchlist? ", message: "View your watchlist in My Coins", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { action in

            if (MyCoinsViewController.coins.contains(where: {$0.name==self.coin.name}))
            {
                print("coin already added")
                self.coinAlreadyAdded()
                
            } else {
                MyCoinsViewController.coins.append(self.coin)
            }
            Coin.saveCoins(MyCoinsViewController.coins)
            for coin in MyCoinsViewController.coins {
                    print(coin.name)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
 
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // button to go to Coinmarketcap URL
    @IBAction func cmcPressed(_ sender: Any) {
        let url = NSURL(string: "https://coinmarketcap.com/currencies/" + coin.name)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    // button to do a Google Search
    @IBAction func googlePressed(_ sender: Any) {
        let url = NSURL(string: "https://www.google.nl/search?q=" + coin.name)
        UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
    }
    
    // alert user when a coin is already in their WatchList
    func coinAlreadyAdded() {
        let alert = UIAlertController(title: "Coin Already Added", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel",
                                          style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set name as title
        nameLabel.text = coin.name.firstUppercased
        
        // set developer activity
        if coin.TwelveWeeksDev < 0 {
            devActivity.text = String(format: "%.2f", coin.TwelveWeeksDev) + "%"
            devActivity.textColor = UIColor.red
        }
        else {
            devActivity.text = "+" + String(format: "%.2f", coin.TwelveWeeksDev) + "%"
            devActivity.textColor = UIColor.green
        }
        
        // set last known 24hr trade volume
        let volume24h = coin.volumeArray.last as! Float
        lastvolume24h.text = "\u{20AC}" + String(format: "%.2f", volume24h)
        lastvolume24h.textColor = UIColor.black
        
        // create chart for developer activity
        let series = ChartSeries(coin.commitArray)
        series.color = ChartColors.greenColor()
        chart.xLabels = [52, 39, 26, 13, 0]
        chart.xLabelsFormatter = { "w" + String(Int(round($1))) }
        chart.add(series)
        
        // create chart for trade volume
        let volumeseries = ChartSeries(coin.volumeArray as! [Float])
        volumeseries.color = ChartColors.redColor()
        volumeChart.showXLabelsAndGrid = false
        volumeChart.showYLabelsAndGrid = false
        volumeChart.add(volumeseries)
        
        // create chart for trends
        let trendseries = ChartSeries(coin.trendArray )
        trendseries.color = ChartColors.blueColor()
        trendChart.showXLabelsAndGrid = false
        trendChart.showYLabelsAndGrid = false
        trendChart.add(trendseries)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

