//
//  GameViewController.swift
//  ARScavengerHunt
//
//  Created by Zhengran Jiang on 11/26/21.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    var timer: Timer?
    lazy var timeLeft = 10
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        DispatchQueue.main.async {
            self.timerLabel.text = "\(self.timeLeft)"
        }

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            timerLabel.text = ""
            performSegue(withIdentifier: "goToEndGame", sender: nil)
            timeLeft = 3
            DispatchQueue.main.async {
                self.timerLabel.text = ""
            }
        }
    }
    
    
    @IBAction func quit(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil

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
