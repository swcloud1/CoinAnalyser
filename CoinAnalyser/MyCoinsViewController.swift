//
//  MyCoinsViewController.swift
//  CoinMockup
//
//  Created by Siwa Sardjoemissier on 12/01/2018.
//  Copyright © 2018 Siwa Sardjoemissier. All rights reserved.
//

import UIKit


class MyCoinsViewController: UITableViewController {
    
    static var coins = [Coin]() // array of coins to be diplayed as WatchList
    
    
    // allow user to share all coins in WatchList including URLS
    @IBAction func sharePressed(_ sender: Any) {
        
        var coinNames = "These are the Coins I Follow: \n"
        for coin in MyCoinsViewController.coins {
            coinNames += "\n" + coin.name.firstUppercased + ": \n" + "http://coinmarketcap.com/currencies/" + coin.name + "\n"
        }
        let activityVC = UIActivityViewController(activityItems: [coinNames], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBOutlet var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // provide DetailView with the correct coininformation to display
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "detailView" {
            let coinDetails = segue.destination as! CoinDetailsViewController
            let index = tableView.indexPathForSelectedRow!.row
            coinDetails.coin = MyCoinsViewController.coins[index]
        }
    }
    
    // allow for swipe-deletion in WatchList
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            MyCoinsViewController.coins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Coin.saveCoins(MyCoinsViewController.coins)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycoinsprototype", for: indexPath)
        let coin = MyCoinsViewController.coins[indexPath.row]
        cell.textLabel?.text = coin.name.firstUppercased
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyCoinsViewController.coins.count
    }

}
