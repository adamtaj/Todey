//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String) // permet de print le dossier où les données ont été sauvegardées
        
        //print(Realm.Configuration.defaultConfiguration.fileURL) //print the location of the realmURL
      
        
        // On initialise la base de données RealM
         do {
             _ = try Realm()
           
         } catch {
             print("Error initialising new realm, \(error)")
         }
         
        
        
        return true
    }

   

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
    
    }
    


}

