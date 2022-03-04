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
    fileprivate var organizations = [Organization]()
    
    var context: NSManagedObjectContext! {
        didSet {
            fetchData()
        }
    }
    
    func fetchData() {
        let predicate = NSPredicate(format: "name like '*Org'")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)     //сортировка по возрастанию true
        
        let request = NSFetchRequest<Organization>(entityName: "Organization")      //получение данных из CoreData через NSFetchRequest(дорогая операция)
        request.fetchLimit = 3      //ограничение запроса из БД до 3 единиц
        request.predicate = predicate
        request.sortDescriptors = [ sortDescriptor ]
        organizations = try! context.fetch(request)
        tView.reloadData()
        tView.refreshControl?.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tView.refreshControl = UIRefreshControl()
        
        tView.refreshControl?.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath )
        let organization = organizations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = organization.name
        content.secondaryText = "Employees \(organization.employee?.accessibilityElementCount() ?? 0)"      //????
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}


    
