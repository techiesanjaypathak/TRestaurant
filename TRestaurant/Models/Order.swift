//
//  Order.swift
//  TRestaurant
//
//  Created by SanjayPathak on 24/01/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import Foundation

enum TeaType: String, Codable, CaseIterable {
    case gingertea
    case lemontea
}

enum TeaSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order:Codable {
    let name:String
    let email:String
    let type:TeaType
    let size:TeaSize
}

extension Order {
    
    static var all:Resource<[Order]> = {
        guard let url = URL(string: "http://3133231b-de8f-49ab-aafe-92ad638aac25.mock.pstmn.io/subPath/") else {
            fatalError("URL is incorrect")
        }
        return Resource<[Order]>(url: url)
    }()
    
    init?(_ vm:AddTeaOrderViewModel) {
        guard let name = vm.name,
            let email = vm.email,
            let selectedType = TeaType(rawValue: vm.selectedType!.lowercased()),
            let selectedSize = TeaSize(rawValue: vm.selectedSize!.lowercased()) else {
                return nil
        }
        self.name = name
        self.email = email
        self.size = selectedSize
        self.type = selectedType
    }
}

extension Order {
    static func create(vm: AddTeaOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)
        guard let url = URL(string: "http://3133231b-de8f-49ab-aafe-92ad638aac25.mock.pstmn.io/subPath/") else {
            fatalError("URL is incorrect")
        }
//        String(data: try! JSONEncoder().encode(order), encoding: .utf8)
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Encoding failed")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        return resource
    }
}
