//
//  OrderViewModel.swift
//  TRestaurant
//
//  Created by SanjayPathak on 24/01/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import Foundation

struct OrderListViewModel {
    var orderViewModels:[OrderViewModel]
    init() {
        self.orderViewModels = [OrderViewModel]()
    }
    func orderViewModel(atIndex index:Int) -> OrderViewModel {
        return self.orderViewModels[index]
    }
}

struct OrderViewModel{
    let order: Order
    init(order:Order) {
        self.order = order
    }
}

extension OrderViewModel{
    var name: String {
        return order.name
    }
    var email: String {
        return order.email
    }
    var type: String {
        return order.type.rawValue.capitalized
    }
    var size: String {
        return order.size.rawValue.capitalized
    }
}
