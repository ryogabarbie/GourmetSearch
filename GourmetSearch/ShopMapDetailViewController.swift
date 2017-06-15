//
//  ShopMapDetailViewController.swift
//  GourmetSearch
//
//  Created by Ryoga on 2017/06/14.
//  Copyright © 2017年 Ryoga. All rights reserved.
//

import UIKit
import MapKit

class ShopMapDetailViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var showHereButton: UIBarButtonItem!
    
    var shop: Shop = Shop()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lat = shop.lat {
            if let lon = shop.lon {
                let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let mkcr = MKCoordinateRegionMakeWithDistance(cllc, 500, 500)
                map.setRegion(mkcr, animated: false)
                
                let pin = MKPointAnnotation()
                pin.coordinate = cllc
                pin.title = shop.name
                map.addAnnotation(pin)
            }
        }
        self.navigationItem.title = shop.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - IBAction
    @IBAction func showHereButtonTapped(_ sender: UIBarButtonItem) {
    }
}
