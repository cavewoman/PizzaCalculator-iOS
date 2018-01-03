//
//  CalculatorViewController.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
  @IBOutlet var pizzasLabel: UILabel!
  @IBOutlet var peopleTextField: UITextField!
  
  var pizzaStore: PizzaStore!
  
  var peopleValue: Double? {
    didSet {
      updatePizzasLabel()
    }
  }
  var pizzasValue: Double? {
    if let peopleValue = peopleValue {
      return convertPeopleToPizza(people: peopleValue)
    } else {
      return nil
    }
  }
  
  @IBAction func peopleFieldEditingChanged(_ textField: UITextField) {
    if let text = textField.text, let value = Double(text) {
      peopleValue = value
    } else {
      peopleValue = nil
    }
  }
  
  @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    peopleTextField.resignFirstResponder()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updatePizzasLabel()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showSuggestions"?:
      let suggestionsViewController = segue.destination as! SuggestionsViewController
      if let pizzasValue = pizzasValue {
      suggestionsViewController.suggestions = pizzaStore.getSuggestions(for: pizzasValue)
      } else {
        suggestionsViewController.suggestions = pizzaStore.getSuggestions(for: 0.0)
      }
      suggestionsViewController.pizzaStore = pizzaStore
    default:
      preconditionFailure("Unexpected segues identifier.")
    }
    
  }
  
  func convertPeopleToPizza(people: Double) -> Double {
    let slices = 1.5 * people
    let pizzas = ceil(slices/8)
    return pizzas
  }
  
  func updatePizzasLabel() {
    if let pizzasValue = pizzasValue {
      pizzasLabel.text = "\(pizzasValue)"
    } else {
      pizzasLabel.text = "???"
    }
  }
}
