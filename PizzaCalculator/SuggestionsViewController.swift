//
//  SuggestionsViewController.swift
//  PizzaCalculator
//
//  Created by Anna Chan on 7/3/17.
//  Copyright © 2017 Anna Chan. All rights reserved.
//

import UIKit

class SuggestionsViewController: UITableViewController {
  var suggestions: [Pizza: Int]!
  var pizzaStore: PizzaStore!
  var sortedSuggestions: [String: [Pizza]] = [:]
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sortedSuggestions = pizzaStore.getSortedPizzas(from: Array(suggestions.keys))
    tableView.reloadData()

  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Vegetarian"
    default:
      return "Non Vegetarian"
    }
  }

  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return sortedSuggestions["veg"]!.count
    } else {
       return sortedSuggestions["non-veg"]!.count + 1
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
      print("Suggestions count \(suggestions.count)")
    if indexPath.row < (sortedSuggestions["non-veg"]?.count)! {
      let pizza: Pizza
      print("Index Path Row \(indexPath.row)")
      switch indexPath.section {
      case 0:
        pizza = (sortedSuggestions["veg"]?[indexPath.row])!
      default:
        print(sortedSuggestions)
        pizza = (sortedSuggestions["non-veg"]?[indexPath.row])!
      }
      
      
      cell.textLabel?.text = "\(String(describing: suggestions[pizza]!)) \(pizza.name!)"
      cell.detailTextLabel?.text = "$\(pizza.price! * suggestions[pizza]!)"
    } else {
      cell.textLabel?.text = "Estimated Pretax Total"
      cell.detailTextLabel?.text = "$\(getTotalFromSuggestions(suggestions: suggestions))"
      cell.backgroundColor = UIColor().colorFromHex(hexValue: "9aab89")
    }
    
    return cell
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "ShowPizzaDetails"?:
      let pizza: Pizza
      let pizzaViewController = segue.destination as! PizzaViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
        switch indexPath.section {
        case 0:
          pizza = (sortedSuggestions["veg"]?[indexPath.row])!
          pizzaViewController.pizza = pizza
        default:
          pizza = (sortedSuggestions["non-veg"]?[indexPath.row])!
          pizzaViewController.pizza = pizza
        }
      }
    default:
      preconditionFailure("Unexpected segues identifier.")
    }
  }
  
  func getTotalFromSuggestions(suggestions: [Pizza: Int]) -> Int {
    var total = 0
    suggestions.forEach { (pizza, count) in
      total += pizza.price! * count
    }
    
    return total
  }
}

extension UIColor {
  func colorFromHex(hexValue: String) -> UIColor {
    let (redText, greenText, blueText) = parseHexString(hexValue: hexValue)
    
    let redFloat = Float(redText)
    let greenFloat = Float(greenText)
    let blueFloat = Float(blueText)
    
    let red: Float = redFloat! / 0xff
    let green: Float = greenFloat! / 0xff
    let blue: Float = blueFloat! / 0xff
    
    return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1)
  }
  
  func parseHexString(hexValue: String) -> (String, String, String) {
    var redText: String = "0x"
    var greenText: String = "0x"
    var blueText: String = "0x"
    
    for (index, char) in hexValue.characters.enumerated() {
      switch index {
      case 0, 1:
        redText += "\(char)"
      case 2, 3:
        greenText += "\(char)"
      default:
        blueText += "\(char)"
      }
    }
    return (redText, greenText, blueText)
  }
}

