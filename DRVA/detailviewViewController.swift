//
//  detailviewViewController.swift
//  DRVA
//
//  Created by Sarvesh on 6/23/17.
//  Copyright © 2017 Sarvesh. All rights reserved.
//

import UIKit
import SQLite
class detailviewViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var gender: UITextField!
    @IBAction func deletebutton(_ sender: Any) {
        var deletealert = UIAlertController(title: "Are you sure you want to delete?", message: "All data will be lost", preferredStyle: UIAlertControllerStyle.alert)
        
        deletealert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            do{
                let path = NSSearchPathForDirectoriesInDomains(
                    .documentDirectory, .userDomainMask, true
                    ).first!
                let db = try Connection("\(path)/myfinaldb.sqlite3")
                let users = Table("users")
                let uidexp = Expression<String?>("uniqueid")
                let myquery = users.filter(uidexp == self.uid)
                try db.run(myquery.delete())
                
            }catch let error{
                print(error)
            }
            self.performSegue(withIdentifier: "delete", sender: self)
        }))
        
        deletealert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(deletealert, animated: true, completion: nil)
    }
var uid = String()
var x = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editpressed)), animated: true)
        image.layer.borderWidth=1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.height/2
        image.clipsToBounds = true
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            let db = try Connection("\(path)/myfinaldb.sqlite3")
            let users = Table("users")
            let uidexp = Expression<String?>("uniqueid")
            let namedexp = Expression<String?>("NAME")
            let ageexp = Expression<String?>("AGE")
            let addressexp = Expression<String?>("ADDRESS")
            let genderexp = Expression<String?>("GENDER")
            let myquery = users.filter(uidexp == uid)
            for user in try db.prepare(myquery) {
                name.text = user[namedexp]!
                address.text = user[addressexp]!
                gender.text = user[genderexp]!
                age.text = user[ageexp]!
            }
        }catch let error{
            print(error)
        }

                // Do any additional setup after loading the view.
    }
    func editpressed(){
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donepressed)), animated: true)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: age.center.x - 3, y: age.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: age.center.x + 3,y: age.center.y))
        age.layer.add(animation, forKey: "position")
        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.duration = 0.07
        animation1.repeatCount = 4
        animation1.fromValue = NSValue(cgPoint: CGPoint(x: address.center.x - 7, y: address.center.y))
        animation1.toValue = NSValue(cgPoint: CGPoint(x: address.center.x + 7,y: address.center.y))
        address.layer.add(animation1, forKey: "position")
        age.isUserInteractionEnabled = true
        address.isUserInteractionEnabled = true
        age.layer.borderWidth = 0.5
        age.borderStyle = UITextBorderStyle.roundedRect
        address.layer.borderWidth = 0.5
        address.layer.borderWidth = 1
        x = age.text!
            }
    func donepressed(){
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            let db = try Connection("\(path)/myfinaldb.sqlite3")
            let users = Table("users")
            let uidexp = Expression<String?>("uniqueid")
            let ageexp = Expression<String?>("AGE")
            let addressexp = Expression<String?>("ADDRESS")
            let myquery = users.filter(uidexp == uid)
            var mys = String()
            if let s = age.text{
                mys = s
            }
            let a: Int? = Int(mys)
            var b : Int
            b = 17
            print(a)
            if a != nil{
                b = a!
            }
            print(b)
            if b<18 || b>65{
                let alert = UIAlertController(title: "Alert!", message: "Please enter valid details!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editpressed)), animated: true)
                age.text = x
                age.isUserInteractionEnabled = false
                address.isUserInteractionEnabled = false
                age.layer.borderWidth = 0
                age.borderStyle = UITextBorderStyle.none
                address.layer.borderWidth = 0
                return
            }
            try db.run(myquery.update( ageexp <- age.text))
            try db.run(myquery.update( addressexp <- address.text))
            for user in try db.prepare(myquery){
                print(user[ageexp])
                print(user[addressexp])
            }
            age.isUserInteractionEnabled = false
            address.isUserInteractionEnabled = false
            age.layer.borderWidth = 0
            age.borderStyle = UITextBorderStyle.none
            address.layer.borderWidth = 0
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editpressed)), animated: true)
        }catch let error{
            print(error)
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
