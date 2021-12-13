import UIKit
class FinishScreenViewController: UIViewController {

    var remainingTime: Int = 0;
    
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var scoringInfoLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let room = GameModel.shared.currentRoom
        
        createAnimation()
        
        // Time Remaining
        timeRemaining.text = String(remainingTime) + " seconds remaining"
        
        var scoringInfo: String = ""
        var points: Int = 0
        
        for item in EnvironmentModel.shared.itemsInLocation[room]!
        {
            let readable = EnvironmentModel.shared.getHumanReadable(object: item)
            if GameModel.shared.itemsFoundForRound.contains(item)
            {
                scoringInfo.append("✔\t\(readable)\t100\n")
                points += 100
            }
            else
            {
                scoringInfo.append("\t\(readable)\t0\n")
            }
        }
        
        if GameModel.shared.itemsFoundForRound.count == EnvironmentModel.shared.itemsInLocation[room]!.count
        {
            let timeBonus = remainingTime * 10
            scoringInfo.append("Time Bonus\t\t\t\(timeBonus)\n")
            
            points += timeBonus
            
            score.text = "⭐️ Room was completed! ⭐️"
            PlayerModel.shared.completedRooms.insert(room)
        }
        
        else
        {
            score.text = "Room wasn't completed..."
        }
        
        scoringInfoLabel.text = scoringInfo
        
        if PlayerModel.shared.saveScore(room: room, score: points)
        {
            score.text = "New Highscore: " + String(points)
        }
        else
        {
            score.text = "Total Score: " + String(points)
        }
        
        GameModel.shared.itemsFoundForRound.removeAll()
        
        
//        // Items Found
//        itemsFound.text = "Found: " + GameModel.shared.itemsFoundForRound.joined(separator: ", ")
//
//        // Items Missed
//        let itemsMissed = PlayerModel.shared.getMissedItems(room: room)
//
//        if itemsMissed.count > 0
//        {
//            itemsNotFound.text = "Congratulations! \(room) completed! ⭐️"
//            PlayerModel.shared.completeRoom(room: room)
//        }
//        else
//        {
//            itemsNotFound.text = "Missed: " + itemsMissed.joined(separator: ", ")
//        }
//
//        // Score
//        var points = GameModel.shared.itemsFoundForRound.count * 100
//
//        if GameModel.shared.itemsFoundForRound.count == EnvironmentModel.shared.itemsInLocation[room]!.count
//        {
//            points += remainingTime * 10
//        }
//
//        if PlayerModel.shared.saveScore(room: room, score: points)
//        {
//            score.text = "New Highscore: " + String(points)
//        }
//        else
//        {
//            score.text = "Score: " + String(points)
//        }
    }
    
    func createAnimation(){
//        create confetti like animatin
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: UIScreen.main.bounds.width/2, y: 0)
        let colors: [UIColor] = [
            .systemRed,
            .systemGreen,
            .systemBlue,
            .systemCyan,
            .systemYellow,
            .systemPink,
            .systemPurple
        ]
        let cells: [CAEmitterCell] = colors.compactMap{
            let cell = CAEmitterCell()
            cell.scale = 0.005
            cell.emissionRange = .pi * 2
            cell.lifetime = 10
            cell.birthRate = 5
            cell.velocity = 150
            cell.color = $0.cgColor
            cell.contents = UIImage(named: "white")!.cgImage
            return cell
        }
        layer.emitterCells = cells
        view.layer.addSublayer(layer)
    }
    
    @IBAction func replay(_ sender: UIButton) {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}
