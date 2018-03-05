//
//  AllCoinsViewController.swift
//  CoinMockup
//
//  Created by Siwa Sardjoemissier on 12/01/2018.
//  Copyright © 2018 Siwa Sardjoemissier. All rights reserved.
//

import UIKit
import Firebase

class AllCoinsViewController: UITableViewController, PopUpViewControllerDelegate, UISearchBarDelegate {
    
    // set search parameters
    var filteredData = [Coin]()
    var isSearching = false
    
    // reload table after sorting option is selected
    func popUpViewControllerDidChangeMarker(_ popUpViewController: PopUpViewController) {
        self.allCoinsTable.reloadData()
    }
    
    // show sorting options
    @IBAction func sortPressed (_ sender: UIBarButtonItem) {
        let popUpViewController: PopUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        popUpViewController.delegate = self
        self.present(popUpViewController, animated: true, completion: nil)
    }
    
    // firebase reference
    var ref: DatabaseReference!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // array to hold all coins
    static var coins: [Coin] = []
    
    @IBOutlet var allCoinsTable: UITableView!
    
    override func viewDidLoad() {
        
        // if there are saved coins, load them. If not, load a sample coin in WatchList
        if let savedCoins = Coin.loadCoins(){
            MyCoinsViewController.coins = savedCoins
        } else {
            MyCoinsViewController.coins = Coin.loadSampleCoins()
        }
        
        print("Currently Saved Coins:")
        for coin in MyCoinsViewController.coins {
            print(coin.name)
        }
        
        // get all coin information from FireBase, turn it into a coin struct and append to the coin array
        ref = Database.database().reference().child("coins")

        ref.observe(DataEventType.value, with: { (snapshot) in

            if snapshot.childrenCount > 0 {
                
                print("retreiving names: done")

                AllCoinsViewController.coins.removeAll()

                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    var commitArray = [Float?](repeating: nil, count:52)
                    
                    var volumeArray = [Float?](repeating: 0, count:52)
                    
                    var trendArray = [Float?](repeating: 0, count:52)
                    
                    let coinContent = (snap.value as! NSDictionary)
                    
                    let dev12Weeks = coinContent.value(forKey: "DeveloperActivityPast12Weeks")
                    
                    let volumes = coinContent.value(forKey: "volumes")
                    
                    // only use coins with both development data and trade volume data
                    if let dev12Weeks != nil {
                        
                        if volumes != nil {
                            
                            let commits = coinContent.value(forKey: "commits") as! NSDictionary
                            
                            for commit in commits {
                                var commitindex = String(describing: commit.key)
                                commitindex.remove(at: commitindex.startIndex)
       
                                commitArray[Int(commitindex)! - 1] = commit.value as? Float
                                
                            }
                            commitArray = commitArray.reversed()
                            
                            for volume in volumes as! NSDictionary {
                                var volumeindex = String(describing: volume.key)
                                volumeindex.remove(at: volumeindex.startIndex)

                                volumeArray[Int(volumeindex)! - 1] = volume.value as? Float
                            }

                            volumeArray = volumeArray.reversed()
                            
                            let trends = coinContent.value(forKey: "searchtrends")
                            
                            if trends != nil {
                                
                                var counter = 0
                                for trend in trends as! NSArray {

                                    trendArray[counter] = trend as? Float
                                    counter += 1
                                    

                                }
                            }
                            // create coin and append to the list
                            let coin = Coin(name: (snap.key), TwelveWeeksDev: (dev12Weeks as! Double), commitArray: (commitArray as! [Float]), volumeArray: (volumeArray as! [Float]), trendArray: (trendArray as! [Float]))
 
                            AllCoinsViewController.coins.append(coin)
                        }

                    }
                }
                self.allCoinsTable.reloadData()
            }
        })
        
        // parameters for searchbar
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.search
        self.tableView.scrollsToTop = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
    }
    
    // searching for coins
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = AllCoinsViewController.coins.filter({$0.name.lowercased().contains(searchBar.text?.lowercased() as! String)})
            
            tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filteredData.count
        } else {
            return AllCoinsViewController.coins.count
        }
    }
    
    // provide DetailView with the correct coininformation to display
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "detailView" {
            let coinDetails = segue.destination as! CoinDetailsViewController
            let index = tableView.indexPathForSelectedRow!.row
            if isSearching {
                coinDetails.coin = filteredData[index]
            } else {
                coinDetails.coin = AllCoinsViewController.coins[index]
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "allcoinsprototype", for: indexPath)
        
        let coin: Coin
        
        if isSearching {
            coin = filteredData[indexPath.row]
        } else {
            coin = AllCoinsViewController.coins[indexPath.row]
        }
        
        cell.textLabel?.text = coin.name.firstUppercased
        
        if coin.TwelveWeeksDev < 0 {
            cell.detailTextLabel?.text = String(format: "%.2f", coin.TwelveWeeksDev) + "%"
            cell.detailTextLabel?.textColor = UIColor.red
        }
        else {
            cell.detailTextLabel?.text = "+" + String(format: "%.2f", coin.TwelveWeeksDev) + "%"
            cell.detailTextLabel?.textColor = UIColor.green
        }

        return cell
    }

}

// Extention for capitalizing first letters
extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}


