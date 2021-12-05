//
//  GameViewController.swift
//  ARScavengerHunt
//
//  Created by Zhengran Jiang on 11/26/21.
//
//

import UIKit

class GameViewController: UIViewController {
    
    var transparentView = UIView()
    var tableView = UITableView()
    var height:CGFloat = 250
    
    var room:String = GameModel.shared.getRoom();
    var itemsToFound:[String] = EnviornmentModel.shared.getRemainingItemsWithRooms(room: GameModel.shared.getRoom());
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLeft = EnviornmentModel.shared.getTimeWithRooms(room: room)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        tableView.isScrollEnabled = true;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
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
    
    
    @IBAction func showItems(_ sender: UIButton) {
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)
        
        let screensize = UIScreen.main.bounds.size
        tableView.frame = CGRect(x: 0, y: screensize.height, width: screensize.width, height: self.height)
        tableView.backgroundColor = UIColor.white
        
        window?.addSubview(tableView)
          
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
          
        transparentView.alpha = 0
          
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: screensize.height - self.height, width: screensize.width, height: self.height)
          }, completion: nil)
        
    }
    
    @objc func onClickTransparentView() {
           let screensize = UIScreen.main.bounds.size
           UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
               self.transparentView.alpha = 0
               self.tableView.frame = CGRect(x: 0, y: screensize.height, width: screensize.width, height: self.height)
//               self.tableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
             }, completion: nil)
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

extension GameViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return number of items in room
        return EnviornmentModel.shared.getRemainingItemsWithRooms(room: self.room).count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else{
            fatalError("unable to deque cell")
        }
        cell.label.text = self.itemsToFound[indexPath.row]
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    
}
