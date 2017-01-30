//
//  VolumioController.swift
//  Volumio
//
//  Created by Michael Baumgärtner on 29.01.17.
//  Copyright © 2017 Federico Sintucci. All rights reserved.
//

import UIKit

protocol VolumioController {
    func connectToVolumio()
    func volumioConnected()
    func volumioDisconnected()
}

extension VolumioController where Self: UIViewController {
    
    /// Connects to volumio if there is no connection yet or tries to get current state otherwise.
    func connectToVolumio() {
        if !VolumioIOManager.shared.isConnected && !VolumioIOManager.shared.isConnecting {
            VolumioIOManager.shared.connectDefault()
        }
        else {
            VolumioIOManager.shared.getState()
        }
    }
    
    // MARK: - Volumio Callbacks
    
    func volumioConnected() {
        Log.entry(self, message: "Volumio connected")
    }
    
    func volumioDisconnected() {
        Log.entry(self, message: "Volumio disconnected")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchingViewController") as! SearchVolumioViewController
        present(controller, animated: true, completion: nil)
    }
    
}
