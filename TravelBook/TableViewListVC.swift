//
//  TableViewListVC.swift
//  TravelBook
//
//  Created by MAKAN on 19.04.2020.
//  Copyright © 2020 YUNUS MAKAN. All rights reserved.
//

import UIKit
import CoreData


class TableViewListVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var titleArray = [String]()
    var idArray = [UUID]()
    var choosenTitle = ""
    var choosenTitleId : UUID?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("NewPlaces"), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        
        
    }
    
    @objc func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
                
            for result in results as! [NSManagedObject]{
                if let title = result.value(forKey: "title") as? String{
                    self.titleArray.append(title)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.tableView.reloadData()
            }
            }
        } catch  {
            print("Error")
        }
       
    }
    
    
    
    
    @objc func addButtonClicked(){
        
        choosenTitle = ""
        
        performSegue(withIdentifier: "toVC", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row] 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenTitle = titleArray[indexPath.row]
        choosenTitleId = idArray[indexPath.row]
        self.performSegue(withIdentifier: "toVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVC" {
        let destinationVC = segue.destination as! ViewController
        destinationVC.selectedTitle = choosenTitle
        destinationVC.selectedTitleId = choosenTitleId
        
        }
        
        
    }
}
