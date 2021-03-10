//
//  ConnectedVIewController.swift
//  SMEmsDemo
//
//  Created by GrayLand on 2021/3/9.
//

import UIKit
import SMEmsSDK
import SnapKit

class ConnectedViewController: UITableViewController {

    @IBOutlet var infoCells: [UITableViewCell]!
    
    //    @IBOutlet weak var exerciseModeCell: UITableViewCell!
    @IBOutlet weak var exerciseModeCell: UITableViewCell!
    @IBOutlet weak var exerciseModeSegment: UISegmentedControl!
    
    @IBOutlet weak var intensityCell: UITableViewCell!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var intensityLabel: UILabel!
    
    @IBOutlet weak var exerciseSecondsCell: UITableViewCell!
    
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minusSecondBtn: UIButton!
    @IBOutlet weak var addSecondBtn: UIButton!
    
    @IBOutlet weak var runModeCell: UITableViewCell!
    @IBOutlet weak var runModeSegment: UISegmentedControl!
    
    @IBOutlet weak var modeEnableSettingCell: UITableViewCell!
    @IBOutlet weak var aerobicSwitch: UISwitch!
    @IBOutlet weak var muscleSwitch: UISwitch!
    @IBOutlet weak var massageSwitch: UISwitch!
    @IBOutlet weak var extendModeCell: UITableViewCell!
    
    var enabledExerciseModes: [SMDeviceExerciseMode] = []
    
    var isAerobicEnabled = true
    var isMuscleEnabled = true
    var isMassageEnabled = true
    
    /// 当前运行模式
    var currentRunMode: SMDeviceRunMode = SMDeviceRunMode.none {
        didSet {
            switch currentRunMode {
            case .working:
                runModeSegment.selectedSegmentIndex = 0
            case .paused:
                runModeSegment.selectedSegmentIndex = 1
            case .stopped:
                runModeSegment.selectedSegmentIndex = 2
            default:
                break
            }
        }
    }
    
    /// 当前训练模式
    var currentExerciseMode: SMDeviceExerciseMode = SMDeviceExerciseMode.none {
        didSet {
            
            var findIndex: Int = NSNotFound
            for (index, ele) in enabledExerciseModes.enumerated() {
                if ele == currentExerciseMode {
                    findIndex = index
                }
            }
            
            if findIndex != NSNotFound {
                exerciseModeSegment.selectedSegmentIndex = findIndex
            }
            
            adjustMaxIntensity()
        }
    }
    
    var exerciseSeconds = 0 {
        didSet {
            self.secondsLabel.text = self.secondsToMMSS(exerciseSeconds)
        }
    }
    var cdTimer: Timer?
    /// 当前训练强度
    var currentIntensity = 1 {
        didSet {
//            currentIntensityPercent = Float(currentIntensity) / Float(maxIntensity)
            intensityLabel.text = "\(currentIntensity)"
            intensitySlider.value = Float(currentIntensity)
        }
    }
//    var currentIntensityPercent:Float = 0.0
    
    var maxIntensity = 32
    var minIntensity = 1
    var isDragging = false
    
    let blePowerOffLabel = UILabel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Disconnect", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onDisconnectBtn))
        
        /// 默认 1200 秒 => 20 分钟,
        exerciseSeconds = 1200
        
        blePowerOffLabel.text = "蓝牙已关闭"
        blePowerOffLabel.isHidden = true
        view.addSubview(blePowerOffLabel)
        blePowerOffLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        
        // 初始默认强度
        setIntensity(intensity: 1, sendCmd: false)
        // 初始默认工作状态
        stoppWorking(sendCmd: false)
        
        #if targetEnvironment(simulator)
        enabledExerciseModes.append(SMDeviceExerciseMode.aerobic)
        enabledExerciseModes.append(SMDeviceExerciseMode.muscle)
        enabledExerciseModes.append(SMDeviceExerciseMode.massage)
        #else
    
        SMEmsManager.defaultManager.currentDevice?.readExerciseModeStatus(mode: SMDeviceExerciseMode.aerobic, completion: nil)
        
        if (isAerobicEnabled) {
            enabledExerciseModes.append(SMDeviceExerciseMode.aerobic)
            aerobicSwitch.isOn = true
        }
        if isMuscleEnabled {
            enabledExerciseModes.append(SMDeviceExerciseMode.muscle)
            muscleSwitch.isOn = true
        }
        if isMassageEnabled {
            enabledExerciseModes.append(SMDeviceExerciseMode.massage)
            massageSwitch.isOn = true
        }
        #endif
        
        // 初始化模式
        updateEnbaleExerciseModes(sendCmd: false, animated: false)
        
        intensitySlider.addTarget(self, action: #selector(self.beginDraggingIntensitySlider), for: UIControl.Event.touchDown)
        intensitySlider.addTarget(self, action: #selector(self.endDraggingIntensitySlider), for: [UIControl.Event.touchUpInside, UIControl.Event.touchUpOutside])
        
        // 添加设备状态监听的代理
        SMEmsManager.defaultManager.delegate.add(self)
        SMEmsManager.defaultManager.currentDevice?.delegate.add(self)
    }
    
    deinit {
        SMEmsManager.defaultManager.delegate.remove(self)
        SMEmsManager.defaultManager.currentDevice?.delegate.remove(self)
    }
    
    // MARK: - Helper
    
    func secondsToMMSS(_ seconds: Int) -> String {
        let mm = Int(floorf(Float(seconds) / 60.0))
        let ss = seconds % 60
        return String.init(format: "%.2d:%.2d", mm, ss)
    }
    
    // MARK: - OnEvent
    @objc func onCDTimer(_ timer: Timer) {
        exerciseSeconds -= 1
        if exerciseSeconds <= 0 {
            cdTimer?.invalidate()
            cdTimer = nil
            
            self.stoppWorking(sendCmd: true)
        }
    }
    
    @objc func beginDraggingIntensitySlider() {
        debugPrint("intensityBeginEditing")
        isDragging = true
    }
    
    @objc func endDraggingIntensitySlider() {
        debugPrint("intensityEndEditing")
        isDragging = false
        self.setIntensity(intensity: currentIntensity, sendCmd: true)
    }
    
    @IBAction func intensitySliderValueDidChanged(_ sender: UISlider) {
        currentIntensity = Int(sender.value)
        debugPrint("intensityValueChanged: \(currentIntensity)")
    }
    
    @IBAction func exerciseModeDidChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        let mode = enabledExerciseModes[index]
        changeExerciseMode(mode: mode, sendCmd: true)
    }
    
    @IBAction func onAddSecBtn(_ sender: Any) {
        exerciseSeconds += 60
    }
    
    @IBAction func onMinusSecBtn(_ sender: Any) {
        if exerciseSeconds > 60 {
            exerciseSeconds -= 60
        }
    }
    
    @IBAction func runModeValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            debugPrint("开始/继续")
            startWorking(sendCmd: true)
        case 1:
            debugPrint("暂停")
            pauseWorking(sendCmd: true)
        case 2:
            debugPrint("停止")
            stoppWorking(sendCmd: true)
        default:
            break
        }
    }
    
    @IBAction func aerobicSwitchChanged(_ sender: UISwitch) {
        isAerobicEnabled = sender.isOn
        debugPrint("aerobicSwitchChanged : \(isAerobicEnabled)")
        updateEnbaleExerciseModes(sendCmd: true, animated: true)
    }
    @IBAction func muscleSwitchChanged(_ sender: UISwitch) {
        isMuscleEnabled = sender.isOn
        debugPrint("muscleSwitchChanged : \(isMuscleEnabled)")
        updateEnbaleExerciseModes(sendCmd: true, animated: true)
    }
    @IBAction func massageSwitchChanged(_ sender: UISwitch) {
        isMassageEnabled = sender.isOn
        debugPrint("massageSwitchChanged : \(isMassageEnabled)")
        updateEnbaleExerciseModes(sendCmd: true, animated: true)
    }
    
    @IBAction func onExtend1(_ sender: UIButton) {
        debugPrint("onExtend1")
        self.testExtendMode(mode: SMDeviceExerciseMode.extend1)
    }
    @IBAction func onExtend2(_ sender: UIButton) {
        debugPrint("onExtend2")
        self.testExtendMode(mode: SMDeviceExerciseMode.extend2)
    }
    @IBAction func onExtend3(_ sender: UIButton) {
        debugPrint("onExtend3")
        self.testExtendMode(mode: SMDeviceExerciseMode.extend3)
    }
    @IBAction func onExtend4(_ sender: UIButton) {
        debugPrint("onExtend4")
        self.testExtendMode(mode: SMDeviceExerciseMode.extend4)
    }
    @IBAction func onExtend5(_ sender: UIButton) {
        debugPrint("onExtend5")
        self.testExtendMode(mode: SMDeviceExerciseMode.extend5)
    }
    @IBAction func onExtend6(_ sender: UIButton) {
        debugPrint("onExtend6")
        self.testExtendMode(mode: SMDeviceExerciseMode.extend6)
    }
    
    @objc func onDisconnectBtn() {
        self.showSystemAlert(self, "Prompt", "Sure to disconnect current deivce and pop back?", "Cancel", cancelHandler: nil, okTitle: "Disconnect") {
            
            SMEmsManager.defaultManager.currentDevice?.setRunMode(mode: SMDeviceRunMode.stopped, completion: { (_, _, _, _) in
                SMEmsManager.defaultManager.disconnectCurrentDevice()
            })
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private
    let map32To9: [Int: Int] = [
        1:1, 2:1, 3:1,
        4:2, 5:2, 6:2, 7:2,
        8:3, 9:3, 10:3,
        11:4, 12:4, 13:4, 14:4,
        15:5, 16:5, 17:5,
        18:6, 19:6, 20:6, 21:6,
        22:7, 23:7, 24:7,
        25:8, 26:8, 27:8, 28:8,
        29:9, 30:9, 31:9, 32:9,
    ]
    let map9To32: [Int: Int] = [1:1, 2:4, 3:8, 4:11, 5: 15, 6:18, 7:22, 8: 25, 9: 29]
    
    func updateEnbaleExerciseModes(sendCmd: Bool, animated: Bool = false) {
        enabledExerciseModes.removeAll()
        if isAerobicEnabled {
            enabledExerciseModes.append(.aerobic)
        }
        SMEmsManager.defaultManager.currentDevice?.setExerciseModeEnable(mode: SMDeviceExerciseMode.aerobic, isEnable: isAerobicEnabled, completion: nil)
        
        if isMuscleEnabled {
            enabledExerciseModes.append(.muscle)
        }
        SMEmsManager.defaultManager.currentDevice?.setExerciseModeEnable(mode: SMDeviceExerciseMode.muscle, isEnable: isMuscleEnabled, completion: nil)
        
        if isMassageEnabled {
            enabledExerciseModes.append(.massage)
        }
        SMEmsManager.defaultManager.currentDevice?.setExerciseModeEnable(mode: SMDeviceExerciseMode.massage, isEnable: isMassageEnabled, completion: nil)
        
        
        if enabledExerciseModes.count == 0 {
            debugPrint("至少要开启 1 个模式!!!")
            isAerobicEnabled = true
            enabledExerciseModes.append(SMDeviceExerciseMode.aerobic)
            aerobicSwitch.isOn = true
            SMEmsManager.defaultManager.currentDevice?.setExerciseModeEnable(mode: SMDeviceExerciseMode.aerobic, isEnable: isAerobicEnabled, completion: nil)
        }
        
        enabledExerciseModes.append(.extend1)
        enabledExerciseModes.append(.extend2)
        enabledExerciseModes.append(.extend3)
        enabledExerciseModes.append(.extend4)
        enabledExerciseModes.append(.extend5)
        enabledExerciseModes.append(.extend6)
        // Update Segment
        exerciseModeSegment.removeAllSegments()
        for ele in enabledExerciseModes {
            switch ele {
            case .aerobic:
                exerciseModeSegment.insertSegment(withTitle: "有氧", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .muscle:
                exerciseModeSegment.insertSegment(withTitle: "增肌", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .massage:
                exerciseModeSegment.insertSegment(withTitle: "按摩", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .extend1:
                exerciseModeSegment.insertSegment(withTitle: "扩1", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .extend2:
                exerciseModeSegment.insertSegment(withTitle: "扩2", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .extend3:
                exerciseModeSegment.insertSegment(withTitle: "扩3", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .extend4:
                exerciseModeSegment.insertSegment(withTitle: "扩4", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .extend5:
                exerciseModeSegment.insertSegment(withTitle: "扩5", at: exerciseModeSegment.numberOfSegments, animated: animated)
            case .extend6:
                exerciseModeSegment.insertSegment(withTitle: "扩6", at: exerciseModeSegment.numberOfSegments, animated: animated)
                
            default:
                break
            }
        }
        
        // Apply ExrciseMode
        changeExerciseMode(mode: enabledExerciseModes.first!, sendCmd: sendCmd)
    }
    
    // MARK: - Table view data source

    enum CellInfo: Int {
        case name = 0
        case sn
        case battery
        case runMode
        case excerciseMode
        case intensity
        case chargeState
        case hubState
        case remainSeconds
        case end
    }
    enum CellAction: Int {
        case excerciseMode = 0
        case intensity
        case exerciseSeconds
        case runMode
        case modeEnableSetting
        case extendModeCell
        case end
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return CellInfo.end.rawValue
        }else if section == 1 {
            return CellAction.end.rawValue
//            return 4
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = infoCells[indexPath.row]
            
            #if targetEnvironment(simulator)
            switch CellInfo.init(rawValue: indexPath.row) {
            case .name:
                cell.textLabel?.text = "设备名称: xxx"
            case .sn:
                cell.textLabel?.text = "设备SN: xxx"
            case .battery:
                cell.textLabel?.text = "剩余电量: xxx"
            case .runMode:
                cell.textLabel?.text = "运行状态: xxx"
            case .excerciseMode:
                cell.textLabel?.text = "当前模式: xxx"
            case .intensity:
                cell.textLabel?.text = "当前模式信号强度: xxx"
            case .chargeState:
                cell.textLabel?.text = "充电状态: xxx"
            case .hubState:
                cell.textLabel?.text = "底座状态: xxx"
            case .remainSeconds:
                cell.textLabel?.text = "剩余运动时长(设备内计时器): xxx"
                
            default:
                break
            }
            #else
            guard let device = SMEmsManager.defaultManager.currentDevice else {
                return cell
            }
            switch CellInfo.init(rawValue: indexPath.row) {
            case .name:
                cell.textLabel?.text = "设备名称: \(device.name)"
            case .sn:
                cell.textLabel?.text = "设备SN: \(device.sn)"
            case .battery:
                cell.textLabel?.text = "剩余电量: \(device.battery)"
            case .runMode:
                cell.textLabel?.text = "运行状态: \(device.runMode)"
            case .excerciseMode:
                cell.textLabel?.text = "当前模式: \(device.excerciseMode)"
            case .intensity:
                cell.textLabel?.text = "当前模式信号强度: \(device.intensity)"
            case .chargeState:
                cell.textLabel?.text = "充电状态: \(device.chargeState)"
            case .hubState:
                cell.textLabel?.text = "底座状态: \(device.hubState)"
            case .remainSeconds:
                cell.textLabel?.text = "剩余运动时长(设备内计时器): \(device.remainSeconds)"
                
            default:
                break
            }
            #endif

            
            return cell
        }else if indexPath.section == 1 {
            switch CellAction.init(rawValue: indexPath.row) {
            case .excerciseMode:
                return exerciseModeCell
            case .intensity:
                return intensityCell
            case .exerciseSeconds:
                return exerciseSecondsCell
            case .runMode:
                return runModeCell
            case .modeEnableSetting:
                return modeEnableSettingCell
            case .extendModeCell:
                return extendModeCell
            default:
                break
            }
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}

extension ConnectedViewController: SMEmsManagerDelegate {
    internal func bleStateDidChanged(_ manager: SMEmsManager, state: CBManagerState) {
        if state == .poweredOff {
            debugPrint("蓝牙已关闭")
            showMessage("蓝牙已关闭")
            tableView.isHidden = true
            blePowerOffLabel.isHidden = false
        }else if state == .poweredOn {
            debugPrint("蓝牙已打开")
            showMessage("蓝牙已打开")
            tableView.isHidden = false
            blePowerOffLabel.isHidden = true
            // Device was disconnected now
        }
    }
    
    func didStartReconnectDevice(bleDevice: SMEmsDevice) {
        debugPrint("正在重连...")
        showWaitting("正在重连...")
    }
    
    func didConnectedDevice(bleDevice: SMEmsDevice?, error: Error?) {
        debugPrint("设备连接成功/重连成功")
        showMessage("设备连接成功/重连成功")
    }
    
    func didDisconnectedDevice(error: Error?) {
        debugPrint("设备连接已断开")
        showMessage("设备连接已断开")
    }
    
    func deviceExecuteTimeout(bleDevice: SMEmsDevice?, action: SMEmsDeviceAction, msg: String?) {
        let desc = "执行操作 \(action) 超时. \(String(describing: msg))"
        debugPrint(desc)
        showMessage(desc)
    }
    
}

extension ConnectedViewController: SMEmsDeviceDelegate {
    func didUpdateStatus(_ device: SMEmsDevice) {
        
        // RunMode Changed
        if device.runMode != currentRunMode {
            // Update Local RunMode
            currentRunMode = device.runMode
            
            if device.runMode == .stopped {
                cdTimer?.invalidate()
                cdTimer = nil
                exerciseSeconds = 1200
            }else if device.runMode == .paused {
                cdTimer?.invalidate()
                cdTimer = nil
            }else if device.runMode == .working {
                self.startWorking(sendCmd: false)
            }
        }
        
        // ExerciseMode Changed
        if device.excerciseMode != currentExerciseMode {
            self.changeExerciseMode(mode: device.excerciseMode, sendCmd: false)
        }
        
        // Intensity Changed
        if device.intensity != currentIntensity && isDragging == false {
            setIntensity(intensity: device.intensity.toInt(), sendCmd: false)
        }
        
        tableView.reloadData()
        
//        tableView.beginUpdates()
//        tableView.reloadSection(0, with: UITableView.RowAnimation.fade)
//        tableView.endUpdates()
    }
}

// MARK: - Action
extension ConnectedViewController {
    
    func startWorking(sendCmd: Bool) {
        currentRunMode = .working
        
        if exerciseSeconds <= 0 {
            exerciseSeconds = 1200
        }
        
        cdTimer?.invalidate()
        cdTimer = nil
        cdTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(self.onCDTimer(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(cdTimer!, forMode: RunLoop.Mode.common)
        
        if sendCmd {
            // Set Mode Only
//            SMEmsManager.defaultManager.currentDevice?.setRunMode(mode: SMDeviceRunMode.working, completion: nil)
            // Set Multi-Property, can sync exerciseSeconds to EMS device.
            SMEmsManager.defaultManager.currentDevice?.setCommandCommit(exerciseMode: currentExerciseMode, exerciseSeconds: exerciseSeconds, intensity: currentIntensity, runMode: currentRunMode, completion: nil)
        }
    }
    
    func pauseWorking(sendCmd: Bool) {
        currentRunMode = .paused
        
        cdTimer?.invalidate()
        cdTimer = nil
        
        if sendCmd {
            SMEmsManager.defaultManager.currentDevice?.setRunMode(mode: SMDeviceRunMode.paused, completion: nil)
        }
    }
    
    func stoppWorking(sendCmd: Bool) {
        currentRunMode = .stopped
        
        cdTimer?.invalidate()
        cdTimer = nil
        exerciseSeconds = 1200
        
        if sendCmd {
            SMEmsManager.defaultManager.currentDevice?.setRunMode(mode: SMDeviceRunMode.stopped, completion: nil)
        }
    }
    
    func changeExerciseMode(mode: SMDeviceExerciseMode, sendCmd: Bool) {
        currentExerciseMode = mode
        if sendCmd {
            SMEmsManager.defaultManager.currentDevice?.setExerciseMode(mode: currentExerciseMode, completion: nil)
        }
    }
    
    /// 测试扩展模式,  强度可以自己调整,
    func testExtendMode(mode: SMDeviceExerciseMode) {
        currentExerciseMode = mode
        currentIntensity = 5
        
        SMEmsManager.defaultManager.currentDevice?.setCommandCommit(exerciseMode: currentExerciseMode, exerciseSeconds: exerciseSeconds, intensity: 5, runMode: SMDeviceRunMode.working, completion: nil)
    }
    
    func adjustMaxIntensity() {
        var toValue = currentIntensity
        if currentExerciseMode == .massage ||
            currentExerciseMode == .extend2 ||
            currentExerciseMode == .extend3 ||
            currentExerciseMode == .extend4 ||
            currentExerciseMode == .extend5 ||
            currentExerciseMode == .extend6{
            if (maxIntensity > 9) {
                maxIntensity = 9
                toValue = map32To9[currentIntensity] ?? 1
            }
            
        }else {
            if maxIntensity <= 9 {
                maxIntensity = 32
                toValue = map9To32[currentIntensity] ?? 1
            }
        }
        
        // 随意是设置一个值用作界面显示, 之后硬件会同步他目前的设置, 到时会自动更新界面到实际的档位
//        let calcV = roundf(currentIntensityPercent * Float(maxIntensity))
//        intensitySlider.value = calcV
        
        intensitySlider.maximumValue = Float(maxIntensity)
        intensitySlider.value = Float(toValue)
        currentIntensity = toValue
    }
    
    func setIntensity(intensity: Int, sendCmd: Bool) {
        currentIntensity = intensity
        
        if (sendCmd) {
            SMEmsManager.defaultManager.currentDevice?.setIntensity(intensity: currentIntensity, completion: nil)
            SMEmsManager.defaultManager.currentDevice?.intensity = UInt8(currentIntensity)
        }
    }
}
