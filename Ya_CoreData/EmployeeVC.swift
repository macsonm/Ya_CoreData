import UIKit
import CoreData

class EmployeeVC: UITableViewController {
    
    @IBOutlet weak var tView: UITableView!
    
    @IBAction func addEmployee(_ sender: Any) {
        guard let context = organization.managedObjectContext else { return }
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee //добавляем в контекст новый объект класса Employee
        
        employee.firstName = "Kate"
        employee.lastName = "K"
        employee.bDate = Date()
        employee.position = "Ios Dev"
        
        organization.addToEmployee(employee)
        
        try! context.save()
    }
    
    var organization: Organization!
    fileprivate let cellIdentifier = "employeesCellIdentifier"
    private var fetchedResultsController: NSFetchedResultsController<Employee>!
    
    func setupFetchedResultsController(for context: NSManagedObjectContext) {
        let predicate = NSPredicate(format: "department = %@", organization)
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        
        request.sortDescriptors = [ sortDescriptor ]
        request.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = organization.name
        setupFetchedResultsController(for: organization.managedObjectContext!)
        try! fetchedResultsController?.performFetch()
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let employee = fetchedResultsController?.object(at: indexPath) else { return cell }
        
        var content = cell.defaultContentConfiguration()
        content.text = employee.lastName
        content.secondaryText = employee.position ?? ""
        cell.contentConfiguration = content
        return cell
    
    }
    
}


extension EmployeeVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            tView.deleteRows(at: [indexPath!], with: .automatic)
            tView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            return
        }
        
    }
    
}
