//
//  AppDelegate.swift
//  FourWaysOfCreatingFetchRequest
//
//  Created by Mazharul Huq on 1/25/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "CountryList")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        importJSONData()
        return true
    }
    
    func importJSONData(){
        let countryFetch:NSFetchRequest<Country> = Country.fetchRequest()
        let count = try! coreDataStack.managedContext.count(for: countryFetch)
        guard count == 0 else { return }
        
        let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let jsonDict = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as! [String:Any]
        let responseDict = jsonDict["response"] as! [String: Any]
        let jsonArray = responseDict["countries"] as! [[String:Any]]
        
        for jsonDictionary in jsonArray {
            let name = jsonDictionary["country"] as? String
            let capital = jsonDictionary["capital"] as? String
            let area = jsonDictionary["area"] as! String
            let population = jsonDictionary["population"] as! String
            
            let country = Country(context: coreDataStack.managedContext)
            country.name = name
            country.capital = capital
            country.area = Int32(area)!
            country.population = Int32(population)!
        }
        coreDataStack.saveContext()
    }
}

