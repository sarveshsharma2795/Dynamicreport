//
//  formview.swift
//  DRVA
//
//  Created by Sarvesh on 6/19/17.
//  Copyright © 2017 Sarvesh. All rights reserved.
//

import UIKit
import DropDown
import SQLite
class formview: UIViewController {
let view1 = UIView()
var dropDown = Array<DropDown>()
let mydropdown = DropDown()
    struct jsonstruct {
        var label = String()
        var nametextfield : UITextField?
        var numbertextfield : UITextField?
        var textview : UITextView?
        var button : UIButton?
    }
var mystruct = Array<jsonstruct>()
var m = String()
var jsontosend = [String : String]()
var dbfields = Array<Expression<String?>>()
var checkjson = [String: String]()
       override func viewDidLoad() {
        
        self.navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
                navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(formview.senddata)), animated: true)
        let upcolor = UIColor(colorLiteralRed: 210/255, green: 236/255, blue: 255/255, alpha: 1)
        let downcolor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let gradientlocation:[Float]=[0.0, 1.0]
        let colorarray:[CGColor]=[upcolor.cgColor, downcolor.cgColor]
        let Gradientlayer:CAGradientLayer=CAGradientLayer()
        Gradientlayer.colors=colorarray
        Gradientlayer.locations=gradientlocation as [NSNumber]?
        Gradientlayer.frame=self.view.bounds
        self.view.layer.insertSublayer(Gradientlayer, at: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(formview.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        let x = Model()
        var i = 0
        var y = 100
        for count in x.jsonforform{
            let a =  x.jsonforform[i]["type"] as! String
            let b = x.jsonforform[i]["field-name"] as! String
                       if a == "text"  {
                let textlabel = UILabel(frame: CGRect(x: 10, y: y, width: 50, height: 21))
                textlabel.text = b.uppercased()
                var newstruct = jsonstruct()
                newstruct.label = b.uppercased()
                let nametextfield = UITextField()
                nametextfield.frame =  CGRect(x: 7, y: y+25, width: Int(self.view.bounds.width-30), height: 20)
                nametextfield.layer.borderWidth = 0.5
                nametextfield.layer.cornerRadius = 6
                nametextfield.backgroundColor = UIColor.white
                nametextfield.autocorrectionType = UITextAutocorrectionType.no
                nametextfield.spellCheckingType = UITextSpellCheckingType.no
                if b == "name"{
                  let newlabel = UILabel(frame: CGRect(x: 58, y: y, width: 300, height: 21))
                    newlabel.text = "*"
                    newlabel.textColor = UIColor.red
                    self.view.addSubview(newlabel)
                        }
                newstruct.nametextfield = nametextfield
                mystruct.append(newstruct)
                self.view.addSubview(textlabel)
                self.view.addSubview((mystruct[i].nametextfield)!)
                }
           else if a == "number"{
                let textlabel = UILabel(frame: CGRect(x: 10, y: y, width: 100, height: 21))
                textlabel.text = b.uppercased()
                var newstruct = jsonstruct()
                newstruct.label = b.uppercased()
                let agetextfield = UITextField()
                agetextfield.frame =  CGRect(x: 7, y: y+25, width: Int(self.view.bounds.width-30), height: 20)
                agetextfield.layer.borderWidth = 0.5
                agetextfield.layer.cornerRadius = 6
                agetextfield.backgroundColor = UIColor.white
                agetextfield.autocorrectionType = UITextAutocorrectionType.no
                agetextfield.spellCheckingType = UITextSpellCheckingType.no
                if b == "age"{
                let newlabel = UILabel(frame: CGRect(x: 10, y: y+45, width: 300, height: 21))
                newlabel.text = "Enter a valid age between 18 and 65"
                newlabel.textColor = UIColor.blue
                self.view.addSubview(newlabel)
                    
                        }
                newstruct.numbertextfield = agetextfield
                mystruct.append(newstruct)
                agetextfield.keyboardType = UIKeyboardType.numberPad
                self.view.addSubview(textlabel)
                self.view.addSubview((mystruct[i].numbertextfield)!)
            }
          else  if a == "multiline"{
                let multilinelabel = UILabel(frame: CGRect(x: 10, y: y, width: 100, height: 21))
                multilinelabel.text = b.uppercased()
                var newstruct = jsonstruct()
                newstruct.label = b.uppercased()
                let textview = UITextView()
                textview.frame = CGRect(x: 7, y: y+25, width: Int(self.view.bounds.width-30), height: 100)
                textview.layer.borderWidth = 0.5
                textview.layer.cornerRadius = 6
                textview.autocorrectionType = UITextAutocorrectionType.no
                textview.spellCheckingType = UITextSpellCheckingType.no
                newstruct.textview = textview
                mystruct.append(newstruct)
                self.view.addSubview(multilinelabel)
                self.view.addSubview((mystruct[i].textview)!)
            }
            else  if a == "dropdown"{
            let myarr = (x.jsonforform[i]["options"] as! NSArray) as Array
            var j = 0
            
            mydropdown.dataSource.removeAll()
            for countnew in myarr{
            mydropdown.dataSource .append("\(myarr[j])")
            j = j+1
            }
            let button = UIButton()
            button.frame = CGRect(x: 10, y: y, width: 100, height: 21)
            view1.frame = CGRect(x: 10, y: y+21, width: 100, height: 0)
            self.view.addSubview(view1)
            button.setTitle("Select↓", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            var newstruct = jsonstruct()
            newstruct.button = button
            newstruct.label = b.uppercased()
            mystruct.append(newstruct)
            self.view.addSubview(button)
            mydropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            button.setTitle("\(item)", for: .normal)
            }
            mystruct[i].button = button
            (mystruct[i].button)!.addTarget(self, action: #selector(formview.buttonpressed), for: .touchUpInside)
            }
            if a == "multiline"{
            y = y+170
            }
            else {
                y = y+90
            }
            i = i+1
            }
        }
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    func buttonpressed(){
        mydropdown.anchorView = view1
        mydropdown.show()
        dropDown.append(mydropdown)
    }
    func senddata(){
        for count in mystruct{
            if let z = count.nametextfield?.text{
                jsontosend.updateValue(z, forKey: count.label)
            }
            if let z = count.numbertextfield?.text{
                jsontosend.updateValue(z, forKey: count.label)
            }
            if let z = count.textview?.text{
                jsontosend.updateValue(z, forKey: count.label)
            }
            if let z = count.button?.titleLabel?.text{
                jsontosend.updateValue(z, forKey: count.label)
            }
        }
        var mys = String()
        if   let s = jsontosend["AGE"]{
            mys = s
        }
        let a: Int? = Int(mys)
        var b : Int
        b = 17
        print(a)
        if a != nil{
          b = a!
        }
            if b<18 || b>65{
                let alert = UIAlertController(title: "Alert!", message: "Please enter valid details!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        
         if jsontosend["NAME"] == "" {
            let alert = UIAlertController(title: "Alert!", message: "Please enter valid details!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
            performSegue(withIdentifier: "segue2", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue2"{
        let vc = segue.destination as! ViewController
                        let uid = NSUUID().uuidString
            jsontosend.updateValue(uid, forKey: "uniqueid")
            print(jsontosend)
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            do{
            let db = try Connection("\(path)/myfinaldb.sqlite3")
            let users = Table("users")
                for count in jsontosend{
                    let myexp = Expression<String?>("\(count.key)")
                    dbfields.append(myexp)
                }

                try db.run(users.create(ifNotExists:true) { t in
                    for count in dbfields{
                        t.column(count, unique : false)
                    }
                })
                var mystring = Array<String>()
                let tableInfo1 = Array(try db.prepare("PRAGMA table_info(users)"))
                    for line in tableInfo1{
                        print(line[1]!, terminator: " ")
                        mystring.append(String(describing: line[1]!))
                }
                print(mystring)
                var newstring = Array<String>()
                checkjson = jsontosend
                for i in 0 ..< mystring.count{
                    var count2 = String()
                for count in checkjson{
                    count2 = count.key
                    if count.key == mystring[i]
                    {
                        break
                    }
                    }
                    if count2 == mystring[i]{
                    checkjson.removeValue(forKey: count2)
                    checkjson.removeValue(forKey: count2)
                    }
                    
                }
                print(checkjson)
                var express = Array<Expression<String?>>()
                for count in checkjson{
                var expresss = Expression<String?>(count.key)
                express.append(expresss)
                }
                for count in express{
                try db.run(users.addColumn(count))
                }
                let tableInfo2 = Array(try db.prepare("PRAGMA table_info(users)"))
                for line in tableInfo2{
                    print(line[1]!, terminator: " ")
                }
                
                let exp = Expression<String?>("uniqueid")
            do{
                try db.run(users.insert(exp <- (jsontosend["uniqueid"])))
                    }catch let error
                    {
                        print("insertion failed")
                        print(error)
                    }
                for count in jsontosend{
                let myquery = users.filter(exp == uid)
                    let myexpnew = Expression<String?>("\(count.key)")
                    do{
                    try db.run(myquery.update(myexpnew <- count.value))
                    }catch let error
                    {
                        print("insertion failed")
                        print(error)
                    }
                }
                
            }catch let error{
                print(error)
            }
            
            vc.name = self.jsontosend["NAME"]!
            vc.age = self.jsontosend["AGE"]!
            vc.jsondata = jsontosend
            print(vc.age)
            
    }
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
