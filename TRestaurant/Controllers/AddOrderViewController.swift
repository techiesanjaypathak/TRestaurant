//
//  AddOrderViewController.swift
//  TRestaurant
//
//  Created by SanjayPathak on 23/01/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import UIKit

protocol AddOrderViewControllerDelegate {
    func addOrderViewControllerDidDSave(order: Order, viewController:UIViewController)
    func addOrderViewControllerDidCancel(viewController:UIViewController)
}

class AddOrderViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var addTeaOderViewModel = AddTeaOrderViewModel()
    private var teaSizeSegmentedControl:UISegmentedControl!
    var addOderViewControllerDelegate: AddOrderViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
}

extension AddOrderViewController {
    @IBAction func cancel(_ sender: Any) {
        if let delegate = self.addOderViewControllerDelegate {
            delegate.addOrderViewControllerDidCancel(viewController: self)
        }
    }
    @IBAction func save(_ sender: Any) {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        let selectedSize = self.teaSizeSegmentedControl.titleForSegment(at: self.teaSizeSegmentedControl.selectedSegmentIndex)
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            debugPrint("Tea Type Not Selected")
            return
        }
        self.addTeaOderViewModel.name = name
        self.addTeaOderViewModel.email = email
        self.addTeaOderViewModel.selectedSize = selectedSize
        self.addTeaOderViewModel.selectedType = self.addTeaOderViewModel.teaTypes[indexPath.row]
        
        WebService().load(resource: Order.create(vm: self.addTeaOderViewModel)) { (result) in
            switch result {
            case .success(let order):
                if let delegate = self.addOderViewControllerDelegate, let order = order {
                    print(order)
                    delegate.addOrderViewControllerDidDSave(order: order, viewController: self)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AddOrderViewController {
    private func setupUI(){
        teaSizeSegmentedControl = UISegmentedControl(items: self.addTeaOderViewModel.cupSizes)
        teaSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(teaSizeSegmentedControl)
        teaSizeSegmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        teaSizeSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
    }
}

extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addTeaOderViewModel.teaTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeaTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.addTeaOderViewModel.teaTypes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
