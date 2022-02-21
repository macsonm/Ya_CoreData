import UIKit
import CoreData

class OrganizationVC: UITableViewController {
    
    @IBOutlet weak var tView: UITableView!
    
    
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
