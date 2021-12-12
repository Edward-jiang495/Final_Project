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
        self.navigationItem.setHidesBackButton(true, animated: false)
        timeRemaining.text = String(timeRemained) + " seconds remaining"
        var itemsfound = PlayerModel.shared.getStartingItemsFoundWithRoom(room: GameModel.shared.getRoom())
        var itemsfound_str = itemsfound.joined(separator:" > ")
//        > is the snow man in snowy chrismas font 
        itemsFound.text = "Founded: " + itemsfound_str
        var itemsnotfound = PlayerModel.shared.getRemainingItemsWithRoom(room: GameModel.shared.getRoom())
        var itemsnotfound_str = itemsnotfound.joined(separator:" > ")
        itemsNotFound.text = "Not founded: " + itemsnotfound_str
        createAnimation()
        // Do any additional setup after loading the view.
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
    
    
    
    
    @IBOutlet weak var timeRemaining: UILabel!
    
    
    @IBOutlet weak var itemsFound: UILabel!
    
    
    @IBOutlet weak var itemsNotFound: UILabel!
    
    
    @IBOutlet weak var score: UILabel!
    
    @IBAction func replay(_ sender: UIButton) {
        let _ = navigationController?.popToRootViewController(animated: true)

    }
    

}
