//
//  MainViewController.swift
//  SMEmsDemo
//
//  Created by GrayLand on 2021/3/8.
//

import UIKit
import SMEmsSDK

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            onStartScanDevices()
        }
    }
    
    func onStartScanDevices() {
        
        #if targetEnvironment(simulator)
            self.performSegue(withIdentifier: "testForConnected", sender: self)
            return
        #endif
        
        if SMEmsManager.defaultManager.isBLEOn {
            self.performSegue(withIdentifier: "pushToScanVC", sender: self)
        }else {
            SMEmsManager.gotoSetting()
        }
    }
}
