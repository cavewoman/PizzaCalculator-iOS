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
  
  func convertPeopleToPizza(people: Double) -> Double {
    let slices = 2 * people
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
