import UIKit
import CoreData

class OrganizationVC: UITableViewController {
    
    @IBOutlet weak var tView: UITableView!
    
   
    @IBAction func addOrgButton(_ sender: Any) {
        print("Hi")
        guard let context = context else { return }

        guard let organization = NSEntityDescription.insertNewObject(forEntityName: "Organization", into: context) as? Organization else { return }
        organization.name = "Aello Org"

        do{
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    fileprivate let cellIdentifier = "OrganizationCellIdentifier"
//fileprivate var organizations = [Organization]()     //вместо массива организаций будем использовать данные из fetchResultsCntroller в "numberOfRowsInSection" и в "cellForRowAt"
    
    var context: NSManagedObjectContext! {
        didSet {
            setupFetchedResultsController(for: context)
            fetchData()
        }
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Organization>?
    
    func setupFetchedResultsController(for context: NSManagedObjectContext) {   //создаем и конфигурирует fetchResultController
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let request = NSFetchRequest<Organization>(entityName: "Organization")
        request.sortDescriptors = [ sortDescriptor ]
        
        //создаем resultController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    func fetchData() {
        
//        let predicate = NSPredicate(format: "name like '*Org'")
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)     //сортировка по возрастанию true
//        let request = NSFetchRequest<Organization>(entityName: "Organization")      //получение данных из CoreData через NSFetchRequest(дорогая операция)
//        request.fetchLimit = 3      //ограничение запроса из БД до 3 единиц
//        request.predicate = predicate
//        request.sortDescriptors = [ sortDescriptor ]
//        organizations = try! context.fetch(request)
        //вместо NSFetchRequst(выше код //) > используем NSFetchedResultsController
        
        try! fetchedResultsController?.performFetch()
        tView.reloadData()
        tView.refreshControl?.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tView.refreshControl = UIRefreshControl()
        
        tView.refreshControl?.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return organizations.count
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath )
//        let organization = organizations[indexPath.row]
        guard let organization = fetchedResultsController?.object(at: indexPath) else { return cell }
        
        var content = cell.defaultContentConfiguration()
        content.text = organization.name
        content.secondaryText = "Employees \(organization.employee?.accessibilityElementCount() ?? 0)"      //????
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}

extension OrganizationVC: NSFetchedResultsControllerDelegate {
    
    // controllerWillChangeContent вызывается перед обновлением таблицы
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tView.beginUpdates()
    }
    
    // controllerWillChangeContent вызывается после всех изменений таблицы
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tView.endUpdates()  //подтверждает все изменения в таблице и запускает анимацию
    }
    
    //этот метод вызывается для каждой добавленной, удаленной и измененной записи. в поле type отображается тип произошедшего изменения
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
    
