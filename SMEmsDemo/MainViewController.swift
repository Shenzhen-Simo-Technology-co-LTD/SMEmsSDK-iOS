//
//  MainViewController.swift
//  SMEmsDemo
//
//  Created by GrayLand on 2021/3/8.
//

import UIKit
import SMEmsSDK
import GLDemoUIKit
import CommonCrypto

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.global(qos: .default).async { [unowned self] in
//            
//            for i in 0..<100 {
//                DispatchQueue.main.async {
//                    print(">>>", i)
//                    showProgressHUD(title: "正在升级", subtitle: String.init(format: "%d%%", i))
//                }
//                Thread.sleep(forTimeInterval: 0.05)
//            }
//            Thread.sleep(forTimeInterval: 1)
//            DispatchQueue.main.async {
//                hideHUD()
//                showMessage("升级完成", duration: 3)
//            }
//        }
        
//        let t1 = Bundle.main.path(forResource: "aaa", ofType: "dat")!
//        let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: t1))
//        for i in 0..<data.count {
//            print(data[i])
//        }
//        let t2 = UnsafeMutablePointer<UInt8>.allocate(capacity: 32)
//        let d2 = NSData(data: data)
//        CC_SHA256(d2.bytes, CC_LONG(1000), t2)
//        var hexResult = ""
//        for i in 0..<32 {
//            let v = t2[i]
//            hexResult += String(format: "%02x", v)
//        }
//       print("hexResult: \(hexResult)")
//        return
//        let fp = Bundle.main.path(forResource: "EMS_HW1001_SW1704", ofType: "smbin")!
//        let fp = Bundle.main.path(forResource: "EMS_HW1001_SW1704", ofType: "smbin")!
////        let fp = Bundle.main.path(forResource: "EMS_HW1001_SW1704", ofType: "bin")!
//        let badData = NSData.init(contentsOfFile: fp)!
//        let dataLength = badData.count
//        print("badData:", dataLength)
//        for i in 0..<10 {
//            print("badData>>>", badData[i], String(format: "%02x", badData[i]))
//        }
//
//        let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: fp))
//        print("rawData:", badData.count)
//        for i in 0..<10 {
//            print("rawData>>>", data[i], String(format: "%02x", data[i]))
//        }
////        let data1 = try? NSData.init(data: Data.init(contentsOf: URL.init(string: fp)!))
////        let data1 = try! NSData.init(data: Data.init(contentsOf: URL.init(fileURLWithPath: fp)))
////        var data1 = NSData.init(contentsOfFile: fp)!
//
//        let s1 = InputStream.init(fileAtPath: fp)
//        let b1 = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
//        s1?.open()
//        s1?.read(b1, maxLength: dataLength)
//
//        var b2 = Array<UInt8>(repeating: 0, count: dataLength)
////        let data1 = NSData.init(bytes: b1, length: 1000)
//
//        for i in 0..<dataLength {
//            b2[i] = (b1+i).pointee
////            print(">>>", data1[i], String(format: "%02x", data1[i]))
//        }
//
//        let data1 = Data(b2)
//        for i in 0..<10 {
//            print(">>>", data1[i], String(format: "%02x", data1[i]))
//        }
//        s1?.close()
//
////        let data1 = try? NSData.init(contentsOfFile: fp, options: [.uncached])
////        let a: [UInt] = Array(repeating: 0, count: 10)
////        let a = UnsafeMutableRawPointer.allocate(byteCount: 10, alignment: 1)
////        data1.getBytes(a, length: 10)
////        for i in 0..<10 {
////            print("raw:", (a+i).load(as: UInt8.self))
////        }
//
//        let data2 = varifyBinData(data: data)
//        print(data2?.count)
    }
    
    public func varifyBinData(data: Data, key: String = "fc84306f347334a9607c") -> NSData? {
        for i in 0..<10 {
            print("readed data: ", data[i])
        }
        let flagLength = 64
        let binDataLength = data.count - flagLength
//        let binData = data.subdata(with: NSRange(location: 0, length: binDataLength)) as NSData
        let binData = data.subdata(in: Range.init(uncheckedBounds: (0, binDataLength)))
//        let binData = NSData(data: data.subdata(with: NSRange(location: 0, length: binDataLength)))
        
        let flagData = data.subdata(in: Range.init(uncheckedBounds: (binDataLength, data.count)))
//        let flagData = data.subdata(with: NSRange(location: binDataLength, length: flagLength))
        let flagString = String(data: flagData, encoding: String.Encoding.utf8)
        var decodeData: [UInt8] = Array<UInt8>(repeating: 0, count: binDataLength)
//        var decodeData = NSMutableData.init(length: binDataLength)
        let rawKey: NSMutableArray = []
        let keyArr = Array(key)
        for i in stride(from: 0, to: keyArr.count, by: 2) {
            let sV = String(keyArr[i ..< i + 2])
            rawKey.add(Int(sV, radix: 16) ?? 0)
        }
        let rawKeyLength = rawKey.count
        
//        let adapt32bitBytes = UnsafeMutableRawPointer.allocate(byteCount: binDataLength, alignment: 1)
//        let decodeBytes = UnsafeMutableRawPointer.allocate(byteCount: binDataLength, alignment: 1)
//        binData.getBytes(adapt32bitBytes, length: 10)
        
//        for i in 0..<10 {
//            print("raw:", (a+i).load(as: UInt8.self))
//        }
        
        for i in binData.indices {
//            let v1 = (adapt32bitBytes + i).load(as: UInt8.self)
            let v1 = binData[i]
            let v = v1 ^ (rawKey[i % rawKeyLength] as! UInt8)
//            decodeBytes.storeBytes(of: v, toByteOffset: i, as: UInt8.self)
//            let v2 = (decodeBytes+i).load(as: UInt8.self)
            if i < 10 {
//                print(v, v1, v2)
                print(">>>v1v2", v, v1)
            }
//            decodeBytes.storeBytes(of: v, toByteOffset: i, as: UInt8.self)
            decodeData[i] = v
//            decodeData?.append((decodeBytes+i), length: 1)
        }
        /*
         32 bit device:
         40 212 212
         132 0 0
         48 0 0
         111 0 0
         52 0 0
         115 0 73
         52 0 128
         51 154 0
         172 204 178
         124 0 0
         
         64 bit device:
         40 212 212
         73 205 205
         0 48 48
         32 79 79
         233 221 221
         86 37 37
         0 52 52
         16 185 185
         241 145 145
         86 42 42
         Optional(39628)
         */
//        let tData = Data(decodeData) as NSData
        let tData = NSData(bytes: decodeData, length: decodeData.count)
//        let tData = NSData(bytes: decodeBytes, length: decodeData.count)
//        let tData = NSMutableData.init(bytes: decodeBytes, length: binDataLength)
//        let tData = NSMutableData.init(length: binDataLength)!
//        let tData = decodeData
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
//        var digest = [UInt8](repeating: 0, count: digestLength)
        
//        var digest2 = UnsafeMutableRawPointer.allocate(byteCount: digestLength, alignment: 1)
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLength)
//        var d1 = Array<UInt8>(repeating: 0x00, count: digestLength)
//        var d1 = Array<UInt8>(repeating: 0x00, count: digestLength)
//        digest.pointee
//        CC_SHA256(tData!.bytes, CC_LONG(binDataLength), digest)
//        CC_SHA256(decodeBytes, CC_LONG(binDataLength), digest)
        CC_SHA256(tData.bytes, CC_LONG(binDataLength), digest)
        var hexResult = ""
        for i in 0..<digestLength {
            let v = digest[i]
            hexResult += String(format: "%02x", v)
        }
        
        if flagString != hexResult {
            print(hexResult)
            for i in 0..<10 {
                print("tData:", tData[i])
            }
            return nil
        }
        return tData
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
