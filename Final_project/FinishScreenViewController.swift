//
//  FinishScreenViewController.swift
//  ARScavengerHunt
//
//  Created by Zhengran Jiang on 11/26/21.
//

import UIKit

class FinishScreenViewController: UIViewController {

    var timeRemained:Int = 0 ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemaining.text = String(timeRemained) + " seconds remaining"
        var itemsfound = PlayerModel.shared.getStartingItemsFoundWithRoom(room: GameModel.shared.getRoom())
        var itemsfound_str = itemsfound.joined(separator:", ")
        itemsFound.text = itemsfound_str
        var itemsnotfound = PlayerModel.shared.getRemainingItemsWithRoom(room: GameModel.shared.getRoom())
        var itemsnotfound_str = itemsnotfound.joined(separator:", ")
        itemsNotFound.text = itemsnotfound_str

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBOutlet weak var timeRemaining: UILabel!
    
    
    @IBOutlet weak var itemsFound: UILabel!
    
    
    @IBOutlet weak var itemsNotFound: UILabel!
    
    
    @IBOutlet weak var score: UILabel!
    
    
    @IBAction func replay(_ sender: UIButton) {
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
