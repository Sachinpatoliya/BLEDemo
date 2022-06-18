//
//  BluetoothListViewController.swift
//  BLELists
//
//  Created by Sachin Patoliya on 18/06/22.
//

import UIKit

class BluetoothListViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tblBluetoothList: UITableView!
    
    //MARK:- Variables
    lazy var viewModel = {
        BluetoothListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblBluetoothList.register(UINib (nibName: "BluetoothCell", bundle: nil), forCellReuseIdentifier: "BluetoothCell")
        //Initialize View Model
        initViewModel()
    }
    
    func initViewModel() {
        // Get Bluetooth List
        viewModel.getBluetoothList()
        
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tblBluetoothList.reloadData()
            }
        }
    }
    
    //MARK:- Button Actions
    @IBAction func refreshAction(_ sender: UIButton){
        
    }
    
}


// MARK: - UITableViewDelegate
extension BluetoothListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension BluetoothListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bluetoothList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell", for: indexPath) as? BluetoothCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.bluetoothList[indexPath.row]
        cell.cellViewModel = cellVM
        return cell
    }
}
