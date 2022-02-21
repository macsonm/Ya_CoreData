//
//  AppDelegate.swift
//  Ya_CoreData
//
//  Created by Maxim M on 18.02.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container: NSPersistentContainer?

    // MARK: - создание стэка Core Data
    func createContainer(complition: @escaping (NSPersistentContainer) -> ()){      //создаем контейнер NSPersistentContainer
        let container = NSPersistentContainer(name: "Ya_CoreData")                        //передаем ему название нашей модели "Model"
        container.loadPersistentStores(completionHandler: { _, error in             //вызываем loadPersistentStores для открытия бд
            guard error == nil else {
                fatalError("Failed to load data")
            }
            DispatchQueue.main.async {
                complition(container)
            }
        })
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createContainer { container in                                             //вызываем функуию для создания стека CoreData
            self.container = container
            if let nc = self.window?.rootViewController as? UINavigationController,     //сохраняем контейнер
               let vc = nc.topViewController as? OrganizationVC
            {
                vc.context = container.viewContext
            }
        }
        
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Ya_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

