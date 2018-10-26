//
//  ChangeLocationViewController.swift
//  Tempest
//
//  Created by Kyle Houts on 10/26/18.
//  Copyright © 2018 Kyle Houts. All rights reserved.
//

import UIKit

class ChangeLocationViewController: UIViewController, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchLocation: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchLocation = searchText
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "unwindToMainScreen", sender: self)
        print(searchLocation)
    }
    
    
    var mainViewController: ViewController?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        
        //        if (segue.identifier == "MainToTimer") {
        //            let vc = segue.destination as! YourViewController
        //            vc.var_name = "Your Data"
        //        }
    }
    
}





