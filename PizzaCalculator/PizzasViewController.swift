//
//  PizzasViewController.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class PizzasViewController: UITableViewController {
  var pizzaStore: PizzaStore!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    navigationItem.leftBarButtonItem = editButtonItem
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return pizzaStore.getAllSortedVegPizzas().count
    default:
      return pizzaStore.getAllSortedNonVegPizzas().count
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Vegetarian"
    default:
      return "Non Vegetarian"
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaCell", for: indexPath)
    
    let pizza: Pizza
    
    switch indexPath.section {
    case 0:
      pizza = pizzaStore.getAllSortedVegPizzas()[indexPath.row]
    default:
      pizza = pizzaStore.getAllSortedNonVegPizzas()[indexPath.row]
    }
    
    cell.textLabel?.text = pizza.name
    cell.detailTextLabel?.text = "$\(pizza.price!)"
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let pizza: Pizza
      switch indexPath.section {
      case 0:
        pizza = pizzaStore.getAllSortedVegPizzas()[indexPath.row]
      default:
        pizza = pizzaStore.getAllSortedNonVegPizzas()[indexPath.row]
      }
      pizzaStore.removePizza(pizza)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "addPizza"?:
      let pizza = pizzaStore.createPizza(name: "", type: "", toppings: [], price: 0)
      let pizzaDetailViewController = segue.destination as! PizzaDetailViewController
      pizzaDetailViewController.pizza = pizza
      pizzaDetailViewController.pizzaStore = pizzaStore
    case "showPizza"?:
      let pizza: Pizza
      let pizzaDetailViewController = segue.destination as! PizzaDetailViewController
      pizzaDetailViewController.pizzaStore = pizzaStore

      if let indexPath = tableView.indexPathForSelectedRow {
        switch indexPath.section {
        case 0:
          pizza = pizzaStore.getAllSortedVegPizzas()[indexPath.row]
          pizzaDetailViewController.pizza = pizza
        default:
          pizza = pizzaStore.getAllSortedNonVegPizzas()[indexPath.row]
          pizzaDetailViewController.pizza = pizza
        }
      }
    default:
      preconditionFailure("Unexpected segues identifier.")
    }
    
  }
  
  public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 61.0
  }
}
