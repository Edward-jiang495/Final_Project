
import UIKit

class GameReadyViewController: UIViewController
{
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var items: UILabel!
    @IBOutlet weak var locations: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var readyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let room = GameModel.shared.currentRoom
        
        locations.text = room.capitalized
        
        time.text = "Time: " + String(EnvironmentModel.shared.times[room]!)
        
        highScore.text = "Highscore: " + String(PlayerModel.shared.scores[room] ?? 0)
        
        let itemText = EnvironmentModel.shared.itemsInLocation[room]!
        items.text = itemText.map { EnvironmentModel.shared.getHumanReadable(object: $0) }.joined(separator: " - ")
    }
    
    @IBAction func ready(_ sender: UIButton) {}
}
