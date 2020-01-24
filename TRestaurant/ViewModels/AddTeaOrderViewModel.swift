//
//  AddTeaOrderViewModel.swift
//  TRestaurant
//
//  Created by SanjayPathak on 24/01/20.
//  Copyright © 2020 Sanjay. All rights reserved.
//

import Foundation

struct AddTeaOrderViewModel {
    var name:String?
    var email:String?
    var selectedSize:String?
    var selectedType:String?
    var teaTypes:[String] {
        return TeaType.allCases.map{ $0.rawValue.capitalized }
    }
    var cupSizes:[String] {
        return TeaSize.allCases.map{ $0.rawValue.capitalized }
    }
}
