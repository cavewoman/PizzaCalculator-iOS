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
  var vegRatio = 0.3
  
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
    return sortPizzasByName(pizzas: allPizzas)
  }
  
  func getAllSortedVegPizzas() -> [Pizza] {
    let vegPizzas = allPizzas.filter { $0.type! == "veg" }
    return sortPizzasByName(pizzas: vegPizzas)
  }
  
  func getAllSortedNonVegPizzas() -> [Pizza] {
    let nonVegPizzas = allPizzas.filter { $0.type! != "veg" }
    return sortPizzasByName(pizzas: nonVegPizzas)
  }
  
  func getSortedPizzas(from pizzas: [Pizza]) -> [String: [Pizza]] {
    var vegPizzas = [Pizza]()
    var nonVegPizzas = [Pizza]()
    
    pizzas.forEach { pizza in
      if pizza.type == "veg" {
        vegPizzas.append(pizza)
      } else {
        nonVegPizzas.append(pizza)
      }
    }
    
    let sortedVegPizzas = sortPizzasByName(pizzas: vegPizzas)
    let sortedNonVegPizzas = sortPizzasByName(pizzas: nonVegPizzas)
    
    return ["veg": sortedVegPizzas, "non-veg": sortedNonVegPizzas]
    
  }
  
  func findPizza(byName key: String) -> Pizza? {
    var pizza = allPizzas.filter { $0.name  == key }
    if pizza.isEmpty {
      return nil
    } else {
      return pizza[0]
    }
  }
  
  func sortPizzasByName(pizzas: [Pizza]) -> [Pizza] {
    return pizzas.sorted { $0.name! < $1.name! }
  }
  
  func createBasePizzas() {
    let basePizzas = [createPizza(name: "Demarco", type: "veg", toppings: ["Mozzarella", "Basil", "EVOO", "Pecorino Romano"], price: 18),
                      createPizza(name: "Super Supreme", type: "non-veg", toppings: ["Pepperoni", "Black Olives", "Green Peppers", "Sausage", "Red Onion", "Mushrooms"], price: 25),
                      createPizza(name: "Pepp and Mush", type: "non-veg", toppings: ["Pepperoni", "Mushroom"], price: 20),
                      createPizza(name: "Spicy Bianca", type: "veg", toppings: ["EVOO", "Mozzarella", "Ricotta", "Garlic", "Basil", "Pecorino Romano", "Calabrian Chiles"], price: 22),
                      createPizza(name: "Veg Out", type: "veg", toppings: ["Sliced Tomatoes", "Artichoke Hearts", "Mushrooms", "Red Onions", "Green Peppers", "Green Olives", "Black Olives"], price: 23),
                      createPizza(name: "Aphro Chicken", type: "non-veg", toppings: ["Lemon Roasted Chicken", "Tomato", "Feta", "Kalamata Olives", "Roasted Red Peppers", "Red Onion", "Pepperoncini Peppers"], price: 25),
                      createPizza(name: "Drunk Pig", type: "non-veg", toppings: ["Vodka Sauce", "Ricotta", "Fennel Sausage", "Mozzarella", "Parmesan", "Crushed Red Pepper"], price: 23),
                      createPizza(name: "Cheese", type: "veg", toppings: ["Cheese"], price: 19),
                      createPizza(name: "Pepperoni", type: "non-veg", toppings: ["Pepperoni"], price: 19),
                      createPizza(name: "Super Hero", type: "non-veg", toppings: ["Pepperoni", "Carmelized Onions","Provolone", "Meatballs", "Smoked Mozzarella", "Black Olives", "Calabrian Chiles", "Oregano"], price: 25),
                      createPizza(name: "Meatball", type: "non-veg", toppings: ["Meatballs", "Ricotta", "Red Onion", "Fresh Garlic", "Basil", "Pecorino Romano"], price: 23),
                      createPizza(name: "Sausage & Peppers", type: "non-veg", toppings: ["Roasted red peppers", "Red onion", "Jalapeno", "Green Pepper", "Crushed Red Pepper", "Parmesan Cheese"], price: 23),
                      createPizza(name: "Little Italy", type: "non-veg", toppings: ["Fennel Sausage", "Pepperoni", "Ricotta", "Calabrian Chiles", "Fresh Garlic", "Basil", "Pecorino Romano"], price: 24),
                      createPizza(name: "Bianca Supreme", type: "non-veg", toppings: ["EVOO", "Fresh Mozzarella", "Spinach", "Mushrooms", "Bacon", "Gorgonzola"], price: 25)]
    allPizzas = basePizzas
  }
  
  func getSuggestions(for count: Double?) -> [Pizza: Int] {
    if let count = count, count > 0 {
      let numOfVeg = ceil(count * vegRatio) - 1
      let numOfNonVeg = count - numOfVeg - 3
      
      let vegPizzas = getAllSortedVegPizzas()
      let nonVegPizzas = getAllSortedNonVegPizzas()
      
      var suggestions = [Pizza]()
      suggestions.append(findPizza(byName: "Cheese")!)
      if count > 1 {
        suggestions.append(findPizza(byName: "Pepperoni")!)
      }
      if count > 2 {
        suggestions.append(findPizza(byName: "Drunk Pig")!)
      }
      
      if numOfVeg > 0 {
        for _ in (0...(Int(numOfVeg) - 1)) {
          let index = Int(arc4random_uniform(UInt32(vegPizzas.count)))
          suggestions.append(vegPizzas[index])
        }
      }
      
      if numOfNonVeg > 0 {
        for _ in (0...(Int(numOfNonVeg) - 1)) {
          let index = Int(arc4random_uniform(UInt32(nonVegPizzas.count)))
          suggestions.append(nonVegPizzas[index])
        }
      }
      
      var groupedSuggestions: [Pizza: Int] = [:]
      
      for pizza in suggestions {
        groupedSuggestions[pizza] = (groupedSuggestions[pizza] ?? 0) + 1
      }
      
      
      return groupedSuggestions
    } else {
      return [:]
    }
  }
}
