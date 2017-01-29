//
//  VolumioController.swift
//  Volumio
//
//  Created by Michael Baumgärtner on 29.01.17.
//  Copyright © 2017 Federico Sintucci. All rights reserved.
//

protocol VolumioController {
    func connectToVolumio()
    func volumioConnected()
    func volumioDisconnected()
}

extension VolumioController {
    
    /// Connects to volumio if there is no connection yet or tries to get current state otherwise.
    func connectToVolumio() {
        if !VolumioIOManager.shared.isConnected && !VolumioIOManager.shared.isConnecting {
            VolumioIOManager.shared.connectDefault()
        }
        else {
            VolumioIOManager.shared.getState()
        }
    }
    
}
