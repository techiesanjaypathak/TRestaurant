//
//  OrdersTableViewController.swift
//  TRestaurant
//
//  Created by SanjayPathak on 23/01/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderListVM = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController else {
            fatalError("Segue failed")
        }
        if let addOrderVC = navC.viewControllers.first as? AddOrderViewController {
            addOrderVC.addOderViewControllerDelegate = self
        }
    }
    
    
}
extension OrdersTableViewController {
    private func populateOrders() {
        WebService().load(resource: Order.all) { [weak self] (result) in
            switch(result){
            case .success(let orders):
                self?.orderListVM.orderViewModels = orders.map(OrderViewModel.init)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension OrdersTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderListVM.orderViewModels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        let orderViewModel = self.orderListVM.orderViewModel(atIndex: indexPath.row)
        cell.textLabel?.text = orderViewModel.type
        cell.detailTextLabel?.text = orderViewModel.size
        return cell
    }
    
}

extension OrdersTableViewController:AddOrderViewControllerDelegate {
    func addOrderViewControllerDidDSave(order: Order, viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
        let orderVM = OrderViewModel(order: order)
        self.orderListVM.orderViewModels.append(orderVM)
        self.tableView.insertRows(at: [IndexPath(row: self.orderListVM.orderViewModels.count - 1, section: 0)], with: .automatic)
    }
    
    func addOrderViewControllerDidCancel(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
}
