//
//  SearchDeviceViewController.swift
//  SMEmsDemo
//
//  Created by GrayLand on 2021/3/9.
//

import UIKit
import SMEmsSDK
import GLDemoUIKit

class SearchDeviceViewController: UITableViewController {

    var discoveredDevices: [SMEmsDevice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SMEmsManager.defaultManager.delegate.add(self)
        
    }

    deinit {
        SMEmsManager.defaultManager.delegate.remove(self)
    }
    
    func gotoConnectedViewController() {
        self.performSegue(withIdentifier: "pushToConnected", sender: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SMEmsManager.defaultManager.stopScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if SMEmsManager.defaultManager.isBLEOn {
            showWaitting("Searching Device")
            SMEmsManager.defaultManager.startScanEmsDevice()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return discoveredDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") ?? UITableViewCell()
        cell.detailTextLabel?.numberOfLines = 0
        
        let device = discoveredDevices[indexPath.row]
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = """
            SN: \(device.sn)
            RSSI: \(device.RSSI)
            """
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = discoveredDevices[indexPath.row]
        showWaitting("Connecting")
        SMEmsManager.defaultManager.stopScan()
        // 是否自动重连
        SMEmsManager.defaultManager.isEnableAutoReconnect = true
        SMEmsManager.defaultManager.connecteDevice(device) { (isSuccessful, errorCode, errorString, _) in
            self.hideHUD()
            if isSuccessful {
                self.gotoConnectedViewController()
            }else {
                self.showMessage("Connected Failed! \(String(describing: errorString))")
            }
        }
    }
}

extension SearchDeviceViewController: SMEmsManagerDelegate {
    func bleStateDidChanged(_ manager: SMEmsManager, state: CBManagerState) {
        if state == .poweredOn {
            showWaitting("Searching Device")
            SMEmsManager.defaultManager.startScanEmsDevice()
        }else if state == .poweredOff {
            hideHUD()
            self.showSystemAlert(self, "Prompt", "BLE Permission Turned Off", "Back", cancelHandler: nil, okTitle: nil, okHandler: nil)
        }
    }
    
    func didDiscoverDevice(bleDevices: [SMEmsDevice]) {
        discoveredDevices = bleDevices
        tableView.reloadData()
        if bleDevices.count == 0 {
            showWaitting("Searching Device")
        }else {
            hideHUD()
        }
    }
}
