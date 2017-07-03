//
//  Pizza.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class Pizza: NSObject, NSCoding {
  var name: String?
  var type: String?
  var toppings: [String]?
  var price: Int?
  var pizzaKey: String?
  
  init(name: String, type: String, toppings: [String], price: Int) {
    self.name = name
    self.type = type
    self.toppings = toppings
    self.price = price
    self.pizzaKey = UUID().uuidString
    
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObject(forKey: "name") as! String?
    type = aDecoder.decodeObject(forKey: "type") as! String?
    toppings = aDecoder.decodeObject(forKey: "toppings") as? [String]
    price = aDecoder.decodeObject(forKey: "price") as! Int?
    pizzaKey = aDecoder.decodeObject(forKey: "pizzaKey") as! String?
    
    super.init()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(type, forKey: "type")
    aCoder.encode(toppings, forKey: "toppings")
    aCoder.encode(price, forKey: "price")
    aCoder.encode(pizzaKey, forKey: "pizzaKey")
  }
}
