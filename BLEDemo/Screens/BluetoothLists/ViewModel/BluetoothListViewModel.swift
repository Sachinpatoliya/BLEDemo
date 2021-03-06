//
//  BluetoothListViewModel.swift
//  BLELists
//
//  Created by Sachin Patoliya on 18/06/22.
//

import Foundation
import CoreBluetooth

class BluetoothListViewModel: NSObject {
    var bluetoothService: BluetoothListViewModel!
    var timer = Timer()
    var stopTimer = Timer()
    var isBluetoothConnected = false
    var noDataAvailableString = ""

    var bluetoothList = [BluetoothListModel]() {
        didSet {
            if bluetoothList.count <= 0 {
                self.noDataAvailableString = CommonStrings.no_devices_found
            }
            reloadTableView?()
        }
    }

    var manager: CBCentralManager? = nil
    var reloadTableView: (() -> Void)?
    var refreshData: ((Bool) -> Void)?
    
    override init(){
        super.init()
    }
    
    func getBluetoothList(){
        manager = CBCentralManager.init(delegate: self, queue: .main)
    }
    
    //Scan near by bluetooth devices
    func scanBLEDevice(){
        timer.invalidate()
        stopTimer.invalidate()
        manager?.scanForPeripherals(withServices: nil, options: nil)
        stopScanTimer()
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        print("Start Timer")
        refreshData?(true)
        scanBLEDevice()
    }

    func stopScanTimer(){
        stopTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stopTimerAction), userInfo: nil, repeats: false)
    }
    
    @objc func stopTimerAction() {
        print("Stop Timer")
        refreshData?(false)
        startTimer()
        manager?.stopScan()
    }
}

extension BluetoothListViewModel: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Device: \(peripheral)")
        print(RSSI)
        if bluetoothList.filter({$0.UUID == peripheral.identifier.uuidString}).count <= 0{
            bluetoothList.append(BluetoothListModel(name: peripheral.name ?? "", RSSIId: RSSI, UUID: peripheral.identifier.uuidString))
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        switch central.state {
        case .poweredOn:
            self.noDataAvailableString = ""
            isBluetoothConnected = true
            scanBLEDevice()
            break
        case .unauthorized:
            self.noDataAvailableString = CommonStrings.bluetooth_not_connected
            self.bluetoothNotConnected()
            break
        case .poweredOff:
            self.noDataAvailableString = CommonStrings.turn_bluetooth_on
            self.bluetoothNotConnected()
            break
        default:
            break
        }
    }
    
    func bluetoothNotConnected(){
        isBluetoothConnected = false
        refreshData?(false)
        reloadTableView?()
    }
}
