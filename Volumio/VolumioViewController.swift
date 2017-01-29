//
//  VolumioViewController.swift
//  Volumio
//
//  Created by Michael Baumgärtner on 29.01.17.
//  Copyright © 2017 Federico Sintucci. All rights reserved.
//

import UIKit

class VolumioViewController: UIViewController, VolumioController, ObservesNotifications {
    
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
    
    // MARK: - Volumio Callbacks
    
    func volumioConnected() {
        Log.info("Volumio connected")
    }
    
    func volumioDisconnected() {
        Log.info("Volumio disconnected")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchingViewController") as! SearchVolumioViewController
        present(controller, animated: true, completion: nil)
    }

}
