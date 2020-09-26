 //  ViewController.swift
//  TipCalculator
//Shantal Ewell on 9/21/20.
//  Copyright © 2020 Special  Topics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
    
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var secondView: UIStackView!
    
    @IBOutlet weak var sliderSplit: UISlider!
    @IBOutlet weak var splitEachPerson: UILabel!
    @IBOutlet weak var totalSplit: UILabel!
    
    @IBOutlet weak var radius: UIView!
    
    @IBOutlet weak var newRadius: UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    //assigning a float to total cost and spitNumber
    var total = Float()
    var splitNumber = Float()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide view when loaded
        self.secondView.alpha = 0
        
        //adding cornerRadius
        radius.layer.cornerRadius = 25;
        radius.layer.masksToBounds = true;
        
        shareButton.layer.cornerRadius = 10
        shareButton.layer.masksToBounds = true;
        shareButton.alpha = 0
        
        newRadius.layer.cornerRadius = 25;
        newRadius.layer.masksToBounds = true;
        
        billField.layer.cornerRadius = 25;
        //adding placeholder to billField
        billField.placeholder = "\(localeConvert(amount: 0))"

        self.billField.setLeftPaddingPoints(25)
        self.billField.setRightPaddingPoints(25)
    }
    
    //recognize user tap
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
        
    }

    @IBAction func calculateTip(_ sender: Any?) {
        
        //saving key and values for bill amount in user defaults
        UserDefaults.standard.set(billField.text!, forKey: "billAmount")
        
        //saving key and values for percentage selectio in user defaults
        UserDefaults.standard.set(tipControl.selectedSegmentIndex, forKey: "percentageSelection")
        
       //animate view
        UIView.animate(withDuration: 0.1,
                       delay: 0.2,
                       animations: {
                       self.secondView.alpha = 1
                       
        })
        
        
        let bill = Double(billField.text!) ?? 0
        
        let tipPercentages = [0.15, 0.18, 0.2]
        
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        
        total = Float(bill + tip)
        
        //Update the tip and total labels
         tipLabel.text = localeConvert(amount: tip)
         totalLabel.text = localeConvert (amount: Double(total))
        
        //hide billField when bill amount is empty
        if (billField.text == ""){
             self.secondView.alpha = 0
        }
        
        //allow initial slider values to show up, made sender optional to account for empty values
        eachPerson(nil)
    }
    
    
    @IBAction func eachPerson(_ sender: UISlider?) {
        
        //round value of slider to nearest integer (return float without the decimals)
         splitNumber = round(sliderSplit.value)
        
        //add split value beside the split text
        splitEachPerson.text! = "Split: \(Int(splitNumber))"
        
        //update what each person has to pay
        totalSplit.text = localeConvert(amount: Double(total / splitNumber))
        
        //hide and show button for payiny via CashApp
        if (splitNumber > 1){
            shareButton.alpha = 1
        }else{
            shareButton.alpha = 0
        }
             
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let defaults = UserDefaults.standard
        
        //retrirving bill amount from user defaults
        billField.text = defaults.string(forKey: "billAmount")
        
        //retrirving percentageSelection amount from user defaults
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "percentageSelection")
        
        //recalculate tip when you open screen so if something is saved in user defaults it will show up
        calculateTip(nil)
        
        //make billField firstResponder so keyboard always show up
        billField.becomeFirstResponder()
    }
    
    //button link to share bill amount between friends
    @IBAction func linkClicked(_ sender: Any) {
        shareBill()
    }
    
    // Create a string with currency formatting based on the device locale
    //convert double to string, change currency based on your region
    func localeConvert (amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    //this function share the bill via CashApp, and show the exact amount they need to pay
    func shareBill(){
        let textToShare = """
        Hey, lets share the payment of the bill.👇
        https://cash.me/$myewell/\(String(format: "%.2f", Double(total / splitNumber)))
        """
        let activity = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            
        self.present(activity, animated: true, completion: nil)
        }
}

    //left and right padding
    extension UITextField {
        func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
        
        func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
