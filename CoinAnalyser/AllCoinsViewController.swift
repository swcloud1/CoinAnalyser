//
//  AllCoinsViewController.swift
//  CoinMockup
//
//  Created by Siwa Sardjoemissier on 12/01/2018.
//  Copyright © 2018 Siwa Sardjoemissier. All rights reserved.
//

import UIKit
import Firebase

class AllCoinsViewController: UITableViewController, PopUpViewControllerDelegate {
    
    
    func popUpViewControllerDidChangeMarker(_ popUpViewController: PopUpViewController) {
        self.allCoinsTable.reloadData()
    }
    
    @IBAction func sortPressed (_ sender: UIBarButtonItem) {
        let popUpViewController: PopUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        popUpViewController.delegate = self
        self.present(popUpViewController, animated: true, completion: nil)
    }
    
    var ref: DatabaseReference!
    
    static var coins: [Coin] = []
    
    @IBOutlet var allCoinsTable: UITableView!
    
    override func viewDidLoad() {
        
        ref = Database.database().reference().child("coins")

        ref.observe(DataEventType.value, with: { (snapshot) in

            if snapshot.childrenCount > 0 {
                
                print("retreiving names: done")

                AllCoinsViewController.coins.removeAll()

                for snap in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    var commitArray = [Float?](repeating: nil, count:52)
                    
                    var volumeArray = [Float?](repeating: 0, count:52)
                    
                    let coinContent = (snap.value as! NSDictionary)
                    
                    let dev12Weeks = coinContent.value(forKey: "DeveloperActivityPast12Weeks")
                    
                    let volumes = coinContent.value(forKey: "volumes")
                    
                    
                    if dev12Weeks != nil {
                        
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

                            print(volumeArray)
                            volumeArray = volumeArray.reversed()
                            
                            let coin = Coin(name: (snap.key), TwelveWeeksDev: (dev12Weeks as! Double), commitArray: (commitArray as! [Float]), volumeArray: (volumeArray as! [Float]))
                            
//                            print(volumeArray)
                            AllCoinsViewController.coins.append(coin)
                        }

                    }
                }
                
                self.allCoinsTable.reloadData()
            }
        })
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllCoinsViewController.coins.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        if segue.identifier == "detailView" {
            let coinDetails = segue.destination as! CoinDetailsViewController
            let index = tableView.indexPathForSelectedRow!.row
            coinDetails.coin = AllCoinsViewController.coins[index]
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "allcoinsprototype", for: indexPath)
        
        let coin: Coin
        
        coin = AllCoinsViewController.coins[indexPath.row]

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

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
