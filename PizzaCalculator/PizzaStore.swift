//
//  PizzaStore.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class PizzaStore {
  var allPizzas = [Pizza]()
  
  let pizzaArchiveURL: URL = {
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("pizzas.archive")
  }()
  
  init() {
    if let archivedPizzas = NSKeyedUnarchiver.unarchiveObject(withFile: pizzaArchiveURL.path) as? [Pizza] {
      if archivedPizzas.isEmpty {
        createBasePizzas()
      } else {
        allPizzas = archivedPizzas
      }
    } else {
      createBasePizzas()
    }
  }
  
  @discardableResult func createPizza(name: String, type: String, toppings: [String], price: Int) -> Pizza {
    let newPizza = Pizza(name: name, type: type, toppings: toppings, price: price)
    
    allPizzas.append(newPizza)
    return newPizza
  }
  
  func removePizza(_ pizza: Pizza) {
    if let index = allPizzas.index(of: pizza) {
      allPizzas.remove(at: index)
    }
  }
  
  func saveChanges() -> Bool {
    print("Saving pizzas to: \(pizzaArchiveURL.path)")
    return NSKeyedArchiver.archiveRootObject(allPizzas, toFile: pizzaArchiveURL.path)
  }
  
  func getAllSortedPizzas() -> [Pizza] {
    return allPizzas.sorted { $0.name! < $1.name! }
  }
  
  func getAllSortedVegPizzas() -> [Pizza] {
    let vegPizzas = allPizzas.filter { $0.type! == "veg" }
    return vegPizzas.sorted { $0.name! < $1.name! }
  }
  
  func getAllSortedNonVegPizzas() -> [Pizza] {
    let nonVegPizzas = allPizzas.filter { $0.type! != "veg" }
    return nonVegPizzas.sorted { $0.name! < $1.name! }
  }
  
  func createBasePizzas() {
    let basePizzas = [createPizza(name: "Demarco", type: "veg", toppings: ["Mozzarella", "Basil", "EVOO", "Pecorino Romano"], price: 18),
                      createPizza(name: "Super Supreme", type: "non-veg", toppings: ["Pepperoni", "Black Olives", "Green Peppers", "Sausage", "Red Onion", "Mushrooms"], price: 25),
                      createPizza(name: "Pepp and Mush", type: "non-veg", toppings: ["Pepperoni", "Mushroom"], price: 20),
                      createPizza(name: "Spicy Bianca", type: "veg", toppings: ["EVOO", "Mozzarella", "Ricotta", "Garlic", "Basil", "Pecorino Romano", "Calabrian Chiles"], price: 22),
                      createPizza(name: "Veg Out", type: "veg", toppings: ["Sliced Tomatoes", "Artichoke Hearts", "Mushrooms", "Red Onions", "Green Peppers", "Green Olives", "Black Olives"], price: 23),
                      createPizza(name: "Aphro Chicken", type: "non-veg", toppings: ["Lemon Roasted Chicken", "Tomato", "Feta", "Kalamata Olives", "Roasted Red Peppers", "Red Onion", "Pepperoncini Peppers"], price: 25),
                      createPizza(name: "Drunk Pig", type: "non-veg", toppings: ["Vodka Sauce", "Ricotta", "Fennel Sausage", "Mozzarella", "Parmesan", "Crushed Red Pepper"], price: 23),
                      createPizza(name: "Margherita", type: "veg", toppings: ["Mozzarella", "Basil", "EVOO", "Sea Salt"], price: 19),
                      createPizza(name: "Roasted Mushroom", type: "veg", toppings: ["EVOO", "Assorted Mushrooms", "Mozzarella", "Tomato Slices", "Capers", "Thyme", "Sea Salt"], price: 19)]
    allPizzas = basePizzas
  }
}
