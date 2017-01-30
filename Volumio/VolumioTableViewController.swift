//
//  VolumioTableViewController.swift
//  Volumio
//
//  Created by Michael Baumgärtner on 29.01.17.
//  Copyright © 2017 Federico Sintucci. All rights reserved.
//

import UIKit

class VolumioTableViewController: UITableViewController, VolumioController, ObservesNotifications {
    
    var observers: [AnyObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerObserver(forName: .connected) { (notification) in
            self.volumioConnected()
        }
        registerObserver(forName: .disconnected) { (notification) in
            self.volumioDisconnected()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        connectToVolumio()
        
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unregisterObservers()
        
        super.viewDidDisappear(animated)
    }
    
}
