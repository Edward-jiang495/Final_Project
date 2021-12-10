//
//  GameReadyViewController.swift
//  ARScavengerHunt
//
//  Created by Zhengran Jiang on 11/26/21.
//

import UIKit

class GameReadyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        locations.text = "PlayerModel.shared.getCurrentRoom()"
        // Do any additional setup after loading the view.
//        var room = GameModel.shared.getRoom()
//        locations.text = room
//        time.text = String(EnviornmentModel.shared.getTimeWithRooms(room: room)) + " seconds "
//        highScore.text = "Highscore: " + String(PlayerModel.shared.getHighScoreWithRoom(room: room))
//        var remainingitems = PlayerModel.shared.getRemainingItemsWithRoom(room: room)
//        var remainingitemstxt = "";
//        for element in remainingitems{
//            remainingitemstxt = remainingitemstxt + " " + element
//        }
//        items.text = remainingitemstxt
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var room = GameModel.shared.getRoom()
        locations.text = room
        time.text = String(EnviornmentModel.shared.getTimeWithRooms(room: room)) + " seconds "
        highScore.text = "Highscore: " + String(PlayerModel.shared.getHighScoreWithRoom(room: room))
        var remainingitems = PlayerModel.shared.getRemainingItemsWithRoom(room: room)
        var remainingitemstxt = remainingitems.joined(separator: " > ");
        
        items.text = remainingitemstxt
        

    }
    @IBOutlet weak var highScore: UILabel!
    
    @IBOutlet weak var items: UILabel!
    
    @IBOutlet weak var locations: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var readyButton: UIButton!
    
    
    @IBAction func ready(_ sender: UIButton) {
        
        
    }
    

}
