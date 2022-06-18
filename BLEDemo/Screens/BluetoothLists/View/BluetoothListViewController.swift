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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var noDevicesFound: UILabel!
    
    //MARK:- Variables
    lazy var viewModel = {
        BluetoothListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblBluetoothList.register(UINib (nibName: "BluetoothCell", bundle: nil), forCellReuseIdentifier: "BluetoothCell")
        activityIndicator.startAnimating()
        //Initialize View Model
        initViewModel()
    }
    
    func initViewModel() {
        // Get Bluetooth List
        viewModel.getBluetoothList()
        
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.noDevicesFound.isHidden = self?.viewModel.bluetoothList.count ?? 0 <= 0 ? false : true
                self?.tblBluetoothList.reloadData()
            }
        }
        
        //show activity indicator
        viewModel.refreshData = { isRefresh in
            self.handleActivityIndicator(isRefresh: isRefresh)
        }
    }
    
    //MARK:- Button Actions
    @IBAction func refreshAction(_ sender: UIButton){
        viewModel.scanBLEDevice()
        handleActivityIndicator(isRefresh: true)
    }
    
    func handleActivityIndicator(isRefresh: Bool){
        isRefresh ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        self.refreshButton.isHidden = isRefresh
        self.activityIndicator.isHidden = !isRefresh
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
