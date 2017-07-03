//
//  PizzaDetailViewController.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class PizzaDetailViewController: UIViewController, UITextFieldDelegate {
  var pizza: Pizza! {
    didSet {
      navigationItem.title = pizza.name
    }
  }
  
  var pizzaStore: PizzaStore!
  
  @IBOutlet var nameField: UITextField!
  @IBOutlet var typeField: UITextField!
  @IBOutlet var toppingsField: UITextField!
  @IBOutlet var priceField: UITextField!
  
  @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let pizzaName = pizza.name {
      nameField.text = pizzaName
    }
    
    if let pizzaType = pizza.type {
      typeField.text = pizzaType
    }
    
    if let pizzaToppings = pizza.toppings {
      let toppingsList = pizzaToppings.joined(separator: ",")
      toppingsField.text = toppingsList
    }
    
    if let pizzaPrice = pizza.price {
      priceField.text = "\(pizzaPrice)"
    }
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    view.endEditing(true)
    if let enteredName = nameField.text, enteredName != "" {
      pizza.name = nameField.text
      pizza.type = typeField.text?.lowercased() ?? ""
      pizza.toppings = toppingsField.text?.components(separatedBy: ",") ?? []
      pizza.price = Int((priceField.text)!) ?? 0
    } else {
      pizzaStore.removePizza(pizza)
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
