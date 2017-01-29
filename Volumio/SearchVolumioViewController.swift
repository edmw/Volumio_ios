//
//  SearchVolumioViewController.swift
//  Volumio
//
//  Created by Federico Sintucci on 18/10/16.
//  Copyright © 2016 Federico Sintucci. All rights reserved.
//

import UIKit

class SearchVolumioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    NetServiceBrowserDelegate, NetServiceDelegate
{
    
    @IBOutlet weak var searchResultTable: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    let browser = NetServiceBrowser()

    var services : [NetService] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        navigationItem.titleView = imageView
        
        searchResultTable.delegate = self
        searchResultTable.dataSource = self
        searchResultTable.tableFooterView = UIView(frame: CGRect.zero)

        browser.delegate = self
        browserStartSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearAllNotice()
    }

    @IBAction func refreshBrowser(_ sender: UIBarButtonItem) {
        browser.stop()
        browserStartSearch()
    }
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "service", for: indexPath) as! SelectPlayerTableViewCell
        
        let service = services[indexPath.row]
        cell.playerName.text = service.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        browser.stop()

        pleaseWait()
        
        let service = services[indexPath.row]
        service.delegate = self
        service.resolve(withTimeout: 5);
    }
    
    func browserStartSearch() {
        services.removeAll()
        
        browser.searchForServices(ofType: "_Volumio._tcp", inDomain: "local.")
    }
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser,
        didNotSearch errorDict: [String : NSNumber]
    ) {
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser,
        didFind service: NetService,
        moreComing: Bool
    ) {
        if !moreComing {
            services.removeAll()
        }
        services.append(service)

        DispatchQueue.main.async {
            self.searchResultTable.reloadData()
        }
    }
    
    func netServiceDidResolveAddress(_ service: NetService) {
        setPlayer(service)
        clearAllNotice()
    }
    
    func netService(_ service: NetService, didNotResolve errorDict: [String : NSNumber]){
        clearAllNotice()
        browserStartSearch()
    }
    
    func netServiceDidStop(_ service: NetService) {
        service.delegate = nil
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func setPlayer(_ service: NetService) {
        let name = service.name
        let port = service.port
        guard let host = service.hostName else { return }
        
        let player = Player(name: name, host: host, port: port)
        VolumioIOManager.shared.connect(to: player, setDefault: true)
        
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Localization

extension SearchVolumioViewController {
    
    fileprivate func localize() {
        titleLabel.text = NSLocalizedString("SEARCH_VOLUMIO_TITLE",
            comment: "search volumio view title"
        )
        textLabel.text = NSLocalizedString("SEARCH_VOLUMIO_TEXT",
            comment: "search volumio view text"
        )
    }
    
}
