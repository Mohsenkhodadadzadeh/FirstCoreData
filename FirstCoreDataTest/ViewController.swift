//
//  ViewController.swift
//  FirstCoreDataTest
//
//  Created by mohsen khodadadzadeh on 10/4/18.
//  Copyright © 2018 mohsen khodadadzadeh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var names: [String] = []
    var people : [NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "The New List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    
    ///////////////////////////////////////
    ///////////////////////////////////////
    //      I-SWIFT.IR
    ///////////////////////////////////////
    ///////////////////////////////////////
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "Person")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("fetch data has error : \(err) , \(err.userInfo)")
        }
    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "new Data", message: "Please enter a name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first , let nameToSave = textField.text else {
                return
            }
            self.Save(nameToSave)
            self.tableView.reloadData()
            
        }
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func Save(_ name : String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let err as NSError {
            print("the Save Action has Error : \(err) , \(err.userInfo)")
        }
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
}

