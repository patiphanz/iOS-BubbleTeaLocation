
import UIKit
import Alamofire
import AlamofireImage

class VenueDetailViewController: UIViewController {
    
    var name: String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        Alamofire.request("https://avatars0.githubusercontent.com/u/9919?s=280&v=4").responseImage(completionHandler: { res in
            self.imageView.image = res.result.value
        })
    }
    

}
