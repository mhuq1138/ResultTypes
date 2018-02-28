//
//  ResultViewController.swift
//  ResultTypes
//
//  Created by Mazharul Huq on 2/27/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UITableViewController {
    lazy var coreDataStack = CoreDataStack(modelName: "CountryList")
    var type:[String] = ["Using .countResultType",
                         "Using context count method",
                         "Using .dictionaryResultType for sum",
                         "Using .dictionaryResultType for average",
                         "Using .dictionaryResultType for maximum"]
    var result:[String] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0
        result.append(getCountryCount())
        result.append(getCountryCountAlt())
        result.append(getTotalPopulation())
        result.append(getAverageArea())
        result.append(getMaximumPopulation())

    }
    
    func getCountryCount()->String{
        var result = ""
        let countFetch = NSFetchRequest<NSNumber>(entityName: "Country")
        countFetch.resultType = .countResultType
        do{
            let countResult = try coreDataStack.managedContext.fetch(countFetch)
            if let count = countResult.first{
                result = "#Countries: \(count)"
            }
        }
        catch let error as NSError{
            print("Count cannot fetch \(error), \(error.userInfo)")
        }
        return result
    }
    
    func getCountryCountAlt()->String{
        var result = ""
        let countryFetch:NSFetchRequest<Country> = Country.fetchRequest()
        do{
            let count = try coreDataStack.managedContext.count(for: countryFetch)
            result = "#Countries: \(count)"
        }
        catch let error as NSError{
            print("Count cannot fetch \(error), \(error.userInfo)")
        }
        return result
    }
    
    func getTotalPopulation()->String{
        var result = ""
        //1
        let countryFetch = NSFetchRequest<NSDictionary>(entityName: "Country")
        countryFetch.resultType = .dictionaryResultType
        //2
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "sumPopulations"
        //3
        let countExp = NSExpression(forKeyPath: #keyPath(Country.population))
        
        expressionDesc.expression = NSExpression(forFunction: "sum:",  arguments: [countExp])
        expressionDesc.expressionResultType = .integer32AttributeType
        
        //4
        countryFetch.propertiesToFetch = [expressionDesc]
        
        //5
        
        do{
            let results = try coreDataStack.managedContext.fetch(countryFetch)
            if let dict = results.first,
                let population = dict["sumPopulations"]{
                   result = "Total population: \(String(describing: population)) millions"
            }
        }
        catch let error as NSError{
            print("Count cannot fetch \(error), \(error.userInfo)")
        }
        return result
    }
    
    func getAverageArea()->String{
        var result = ""
        //1
        let countryFetch = NSFetchRequest<NSDictionary>(entityName: "Country")
        countryFetch.resultType = .dictionaryResultType
        //2
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "avgArea"
        //3
        let specialCountExp = NSExpression(forKeyPath: #keyPath(Country.area))
        expressionDesc.expression = NSExpression(forFunction: "average:",  arguments: [specialCountExp])
        expressionDesc.expressionResultType = .integer32AttributeType
        //4
        countryFetch.propertiesToFetch = [expressionDesc]
        //5
        do{
            let results = try coreDataStack.managedContext.fetch(countryFetch)
            if let dict = results.first,
                let area = dict["avgArea"]{
                  result = "Average area: \(String(describing: area)) sq. miles"
            }
        }
        catch let error as NSError{
            print("Count cannot fetch \(error), \(error.userInfo)")
        }
        return result
    }
    
    func getMaximumPopulation()->String{
        var result = ""
        //1
        let countryFetch = NSFetchRequest<NSDictionary>(entityName: "Country")
        countryFetch.resultType = .dictionaryResultType
        //2
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "maxPopulation"
        //3
        let specialCountExp = NSExpression(forKeyPath: #keyPath(Country.population))
        expressionDesc.expression = NSExpression(forFunction: "max:",  arguments: [specialCountExp])
        expressionDesc.expressionResultType = .integer32AttributeType
        //4
        countryFetch.propertiesToFetch = [expressionDesc]
        //5
        do{
            let results = try coreDataStack.managedContext.fetch(countryFetch)
            if let dict = results.first,
                let area = dict["maxPopulation"]{
                result = "Maximum population: \(String(describing: area)) millions"
            }
        }
        catch let error as NSError{
            print("Count cannot fetch \(error), \(error.userInfo)")
        }
        return result
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = type[indexPath.row]
        cell.detailTextLabel?.text = result[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
