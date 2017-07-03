//
//  PizzaViewController.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class PizzaViewController: UIViewController {
  @IBOutlet var toppingsLabel: UILabel!
  
  var pizza: Pizza! {
    didSet {
      navigationItem.title = pizza.name
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let pizzaToppings = pizza.toppings {
      let toppingsList = pizzaToppings.joined(separator: ", ")
      toppingsLabel.text = toppingsList
    }
  }
  
}
