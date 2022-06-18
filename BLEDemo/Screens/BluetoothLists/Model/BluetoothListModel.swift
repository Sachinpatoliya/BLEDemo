//
//  BluetoothListModel.swift
//  BLELists
//
//  Created by Sachin Patoliya on 18/06/22.
//

import Foundation

typealias Bluetooths = [BluetoothListModel]

// MARK: - Bluetooths
struct BluetoothListModel {
    var name: String = ""
    var RSSIId: NSNumber = 0
    var UUID: String = ""
    
    init(name: String, RSSIId: NSNumber, UUID: String){
        self.name = name
        self.RSSIId = RSSIId
        self.UUID = UUID
    }
}
