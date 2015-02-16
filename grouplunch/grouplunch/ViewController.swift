//
//  ViewController.swift
//  grouplunch
//
//  Created by Randy Melder on 1/30/15.
//  Copyright (c) 2015 RCM Software, LLC. All rights reserved.
//

import UIKit

class GroupLunchViewController: UIViewController, UITextFieldDelegate {
    
    let DEFAULT_LABEL_AMT           = "0.00"
    let DEFAULT_LABEL_PAYERS        = "Qty of Payers"
    let DEFAULT_LABEL_TIP           = "Tip"
    let MINIMUM_PAYERS              = 1
    let MINIMUM_TIP_PCT             = 0
    let MINIMUM_BILL_AMT            = 0.0
    let TEXTFIELD_TAG_BILL_AMT      = 111
    
    var qty_payers:Int              = 1
    var pct_tip:Int                 = 0
    var bill_amount:Double          = 0.0
    
    // --------------- UI Outlets -------------- //
    @IBOutlet weak var stepperPayers: UIStepper!
    
    @IBOutlet weak var stepperTip: UIStepper!
    
    @IBOutlet weak var labelQtyPayers: UILabel!
    
    @IBOutlet weak var labelTipPct: UILabel!
    
    @IBOutlet weak var labelAmountTipTotal: UILabel!
    
    @IBOutlet weak var labelAmountPreTipEach: UILabel!
    
    @IBOutlet weak var labelAmountWithTipEach: UILabel!
    
    @IBOutlet weak var labelAmountTotalBill: UILabel!

    @IBOutlet weak var textFieldAmountOnBill: UITextField!
    
    @IBOutlet weak var appversionLabel: UILabel!
    
    // --------------- UI Actions -------------- //
    @IBAction func doAmountChange(sender: UITextField) {
        println("\(__FUNCTION__)")
    }
    @IBAction func doQtyPayers(sender: UIStepper) {
        println("\(__FUNCTION__)")
        var value:Int = Int(sender.value)
        self.view.endEditing(true)
        
        if (value > self.MINIMUM_PAYERS) {
            self.qty_payers = value
        } else {
            self.qty_payers = MINIMUM_PAYERS
            sender.value    = Double(MINIMUM_PAYERS)
        }
        
        self.labelQtyPayers.text = NSString(format: "%@ %d:", self.DEFAULT_LABEL_PAYERS, self.qty_payers)
        
        doCalculateAmounts()
    }
    
    @IBAction func doTipChange(sender: UIStepper) {
        println("\(__FUNCTION__)")
        var value:Int = Int(sender.value)
        self.view.endEditing(true)
        
        if (value > self.MINIMUM_TIP_PCT) {
            self.pct_tip    = value
        } else {
            self.pct_tip    = MINIMUM_TIP_PCT
            sender.value    = Double(MINIMUM_TIP_PCT)
        }
        
        self.labelTipPct.text = NSString(format: "%@ %d%%", self.DEFAULT_LABEL_TIP, self.pct_tip)
        
        doCalculateAmounts()
    }
    
    func doCalculateAmounts() {
        println("\(__FUNCTION__)")
        
        var amtTipTotal:Double      = self.bill_amount * (Double(self.pct_tip) / 100);
        var amtJustTipEach:Double   = amtTipTotal / Double(self.qty_payers)
        var amtPreTipEach:Double    = self.bill_amount / Double(self.qty_payers)
        var amtWithTipEach:Double   = amtJustTipEach + amtPreTipEach
        var amtTotalBill:Double     = amtTipTotal + self.bill_amount
        
        self.labelAmountTipTotal.text   = NSString(format: "%.2lf", amtTipTotal)
        self.labelAmountPreTipEach.text = NSString(format: "%.2lf", amtPreTipEach)
        self.labelAmountWithTipEach.text = NSString(format: "%.2lf", amtWithTipEach)
        self.labelAmountTotalBill.text = NSString(format: "%.2lf", amtTotalBill)
        
    }
    
    func doSetInitialValues() {
        println("\(__FUNCTION__)")
        self.labelAmountTipTotal.text       = self.DEFAULT_LABEL_AMT
        self.labelAmountPreTipEach.text     = self.DEFAULT_LABEL_AMT
        self.labelAmountWithTipEach.text    = self.DEFAULT_LABEL_AMT
        self.labelAmountTotalBill.text      = self.DEFAULT_LABEL_AMT
        self.textFieldAmountOnBill.text     = self.DEFAULT_LABEL_AMT
        
        self.labelQtyPayers.text            = NSString(format: "%@ %d:", self.DEFAULT_LABEL_PAYERS, self.qty_payers)
        self.labelTipPct.text               = NSString(format: "%@ %d%%", self.DEFAULT_LABEL_TIP, self.pct_tip)
        
        self.stepperPayers.value            = 1
        self.stepperTip.value               = 0
    }
    
    // --------------- Delegates ---------------- //
    func textFieldDidBeginEditing(textField: UITextField) {
        println("\(__FUNCTION__)")
        if (self.TEXTFIELD_TAG_BILL_AMT == textField.tag) {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        println("\(__FUNCTION__)")
        var amount:Double = self.MINIMUM_BILL_AMT
        
        if (self.TEXTFIELD_TAG_BILL_AMT == textField.tag) {
            amount          = (textField.text as NSString).doubleValue
        }
        
        self.bill_amount    = amount
        textField.text      = NSString(format: "%1.2lf", amount)
        
        doCalculateAmounts()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("\(__FUNCTION__)")
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // --------------- Built Ins ---------------- //
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        println("\(__FUNCTION__)")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set start amounts
        doSetInitialValues()
        
        self.textFieldAmountOnBill.delegate         = self
        self.textFieldAmountOnBill.keyboardType     = UIKeyboardType.DecimalPad
        
        // Version
        let appversion              = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as NSString) as String
        self.appversionLabel.text   = appversion
        
        
    }

    override func didReceiveMemoryWarning() {
        println("\(__FUNCTION__)")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

