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

    var bluetoothList = [BluetoothListModel]() {
        didSet {
            reloadTableView?()
        }
    }

    var manager: CBCentralManager? = nil
    var reloadTableView: (() -> Void)?

    override init(){
        super.init()
    }
    
    func getBluetoothList(){
        manager = CBCentralManager.init(delegate: self, queue: .main)
    }
    
    //Scan near by bluetooth devices
    func scanBLEDevice(){
        manager?.scanForPeripherals(withServices: nil, options: nil)
    }
}

extension BluetoothListViewModel: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Device: \(peripheral)")
        print(RSSI)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) { //обновление состояния менеджера
        print(central.state)
        switch central.state {
        case .poweredOn:
            scanBLEDevice()
            break
        default:
            break
        }
    }
}
