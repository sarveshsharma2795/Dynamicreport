//
//  ViewController.swift
//  DRVA
//
//  Created by Sarvesh on 6/18/17.
//  Copyright © 2017 Sarvesh. All rights reserved.
//

import UIKit
import DropDown
import SQLite
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet weak var todayreports: UILabel!
    @IBOutlet weak var totalreports: UILabel!
    @IBOutlet weak var sortbutton: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var tableview: UITableView!
    var uidtosend = String()
    let dropDown = DropDown()
    var name = String()
    var age = String()
    var jsondata = [String : String]()
    struct mydetails{
        var myname = String()
        var myage = String()
        var myuid = String()
    }
    var mylabelcount = Array<Int>()
    var newlabelcount = Int()
    var savedarray = Array<mydetails>()
    var detailarray = Array<mydetails>()
    var filterarray = Array<mydetails>()
    let searchcontroller = UISearchController(searchResultsController: nil)
    var reportcount = Int()
override func viewDidLoad() {
        searchcontroller.searchResultsUpdater = self
        searchcontroller.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableview.tableHeaderView = searchcontroller.searchBar
        self.navigationController?.hidesBarsOnTap = false
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableview.delegate = self
        tableview.dataSource = self
    do{
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        let db = try Connection("\(path)/myfinaldb.sqlite3")
        let users = Table("users")
        for user in try db.prepare(users) {
            let nameexp = Expression<String>("NAME")
            let ageexp = Expression<String>("AGE")
            let uidexp = Expression<String>("uniqueid")
                var detailinst = mydetails()
             detailinst.myname = user[nameexp]
            detailinst.myage = user[ageexp]
            detailinst.myuid = user[uidexp]
            detailarray.append(detailinst)
        }
       newlabelcount = detailarray.count
        totalreports.text = String(newlabelcount)
    }catch let error{
        print(error)
    }
    
    savedarray = detailarray
       }
    override func viewDidAppear(_ animated: Bool) {
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            let db = try Connection("\(path)/myfinaldb.sqlite3")
            let users = Table("users")
            detailarray = Array<mydetails>()
            for user in try db.prepare(users) {
                let nameexp = Expression<String>("NAME")
                let ageexp = Expression<String>("AGE")
                let uidexp = Expression<String>("uniqueid")
                var detailinst = mydetails()
                detailinst.myname = user[nameexp]
                detailinst.myage = user[ageexp]
                detailinst.myuid = user[uidexp]
                detailarray.append(detailinst)
                tableview.reloadData()
            }
                     }catch let error{
            print(error)
        }
        do{
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            let db = try Connection("\(path)/myfinaldb.sqlite3")
            let labels = Table("label")
            let numberexp = Expression<String>("number")
            try db.run(labels.create(ifNotExists: true) { t in
            t.column(numberexp)
                 })
            try db.run(labels.insert(numberexp <- "\(newlabelcount)"))
            for user in try db.prepare(labels) {
            mylabelcount.append(Int(user[numberexp])!)
            }
            print(mylabelcount.first!)
            if newlabelcount - mylabelcount.first! > 0{
                todayreports.text = String(newlabelcount - mylabelcount.first!)
            }
        }catch let error{
            print(error)
        }
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchcontroller.isActive && searchcontroller.searchBar.text != ""{
            return filterarray.count
        }else{
        return detailarray.count
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mycellTableViewCell
        if searchcontroller.isActive && searchcontroller.searchBar.text != ""{
            var fildet = filterarray[indexPath.row]
            cell.name.text = fildet.myname
            cell.age.text = fildet.myage
            cell.uid.text = fildet.myuid
        }else{
        var det = detailarray[indexPath.row]
        cell.name.text = det.myname
        cell.age.text = det.myage
        cell.uid.text = det.myuid
        }
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchcontroller.isActive && searchcontroller.searchBar.text != ""{
            let det = filterarray[indexPath.row]
            uidtosend = det.myuid
        }else{
        let det = detailarray[indexPath.row]
        uidtosend = det.myuid
        }
        performSegue(withIdentifier: "details", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details"{
        let vc = segue.destination as! detailviewViewController
            vc.uid = uidtosend
        }
    }
    @IBAction func search(_ sender: Any) {
        
    }
           @IBAction func sortpressed(_ sender: Any) {
        dropDown.anchorView = view1
        dropDown.dataSource = ["Date", "Name", "Age"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.sortbutton.setTitle("\(item)↓", for: .normal)
            if item == "Name"{
                self.detailarray.sort{ $0.myname < $1.myname }
                self.tableview.reloadData()
            }
            if item == "Age"{
                self.detailarray.sort{ $0.myage < $1.myage }
                self.tableview.reloadData()
            }
            if item == "Date"{
                self.detailarray = self.savedarray
                self.tableview.reloadData()
            }
            }
            dropDown.show()
    }
    func filtercontentforsearch(searchstring : String){
        var myarr = Array<String>()
        var filterarr = Array<String>()
        for count in detailarray{
            var inst = mydetails()
            inst.myname = count.myname
            myarr.append(inst.myname)
        }
        filterarr = myarr.filter(){ nil != $0.range(of: searchstring)}
        var newarr = detailarray
        filterarray = Array<mydetails>()
        if filterarr.count > 1 {
            for j in 0 ..< filterarr.count{
            for i in j+1 ..< filterarr.count{
                if filterarr[j] == filterarr[i]{
                    filterarr[i] = NSUUID().uuidString
                }
                
            }
            }
        }
        
        for i in 0 ..< filterarr.count{
        for count in newarr{
            if filterarr[i] == count.myname{
                var inst = mydetails()
                inst.myname = count.myname
                inst.myage = count.myage
                inst.myuid = count.myuid
                self.filterarray.append(inst)
                
            }
            
        }
        }
        tableview.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        self.filtercontentforsearch(searchstring: searchcontroller.searchBar.text!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension Connection {
    public var userVersion: Int32 {
        get { return Int32(try! scalar("PRAGMA user_version") as! Int64)}
        set { try! run("PRAGMA user_version = \(newValue)") }
    }
}
