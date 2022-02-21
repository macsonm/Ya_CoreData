import UIKit
import CoreData

class OrganizationVC: UITableViewController {
    
    @IBOutlet weak var tView: UITableView!
    
   
    @IBAction func addOrgButton(_ sender: Any) {
        print("Hi")
        guard let context = context else { return }

        guard let organization = NSEntityDescription.insertNewObject(forEntityName: "Organization", into: context) as? Organization else { return }
        organization.name = "Yandex"

        do{
            try context.save()
        } catch {
            print(error)
        }
        
        
        
    }
    
    var context: NSManagedObjectContext! {
        didSet {
            tView.refreshControl?.endRefreshing()       
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tView.refreshControl = UIRefreshControl()
        
        tView.refreshControl?.beginRefreshing()
    }
    
}
