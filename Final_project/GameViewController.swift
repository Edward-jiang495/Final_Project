//
//  GameViewController.swift
//  ARScavengerHunt
//
//  Created by Zhengran Jiang on 11/26/21.
//
//

import UIKit
import AVFoundation


class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var transparentView = UIView()
    var tableView = UITableView()
    var height:CGFloat = 250
    var videoManager:VideoAnalgesic! = nil
    var room:String = GameModel.shared.getRoom();
    var itemsToFind:[String] = PlayerModel.shared.getRemainingItemsWithRoom(room: GameModel.shared.getRoom());
    var itemsFound:[String] = PlayerModel.shared.getStartingItemsFoundWithRoom(room: GameModel.shared.getRoom());
    var totalItems:[String] = []
    var isFrontCamera:Bool = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        totalItems = itemsToFind + itemsFound
        timeLeft = EnviornmentModel.shared.getTimeWithRooms(room: room)
        timerLabel.text = String(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        var objToFind3 = ""
        if itemsToFind.count >= 3{
//                more than three items to find
            var arrSlice = itemsToFind[0...2]
            objToFind3 = arrSlice.joined(separator:", ")

        }
        else{
//                less than 3 items to find
            objToFind3 = itemsToFind.joined(separator:", ")
        }
        firstThreeObjectsToFind.text = objToFind3
        
        tableView.isScrollEnabled = true;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.videoManager = VideoAnalgesic(mainView: self.view)
        self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.back)
                
        self.videoManager.setProcessingBlock(newProcessBlock:self.processImage)
                
        if !videoManager.isRunning{
            videoManager.start()
        }
    }
    
    
    
    func processImage(inputImage:CIImage) -> CIImage{
        //return inputImage
//        print("PROCESS")
        return inputImage
    }
    
    var timer: Timer?
    lazy var timeLeft = 10
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var firstThreeObjectsToFind: UITextView!
    
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
    
    
    @IBAction func detectItem(_ sender: UIButton) {
//        this function is for capturing image item
        var item:String = "person"
        if let index = itemsToFind.firstIndex(of:item){
            let element = itemsToFind.remove(at: index)
            itemsFound.append(element)
        }
        PlayerModel.shared.addFoundItem(room: room, itemFound: item)
        
        if let index = totalItems.firstIndex(of: item) {
            var element = totalItems.remove(at: index)
            element = element + "⭐"
//            remove from beginning and append to the end
//            WITH A STAR
            var objToFind3 = ""
            if itemsToFind.count >= 3{
//                more than three items to find
                var arrSlice = itemsToFind[0...2]
                objToFind3 = arrSlice.joined(separator:", ")

            }
            else{
//                less than 3 items to find
                objToFind3 = itemsToFind.joined(separator:", ")
            }
            firstThreeObjectsToFind.text = objToFind3
            
            totalItems.append(element)
            tableView.reloadData()
//            reload table
        }
//        the item that was found
        
        
    }
    
    
    
    @IBAction func toggleCamera(_ sender: UIButton) {
        if isFrontCamera{
            self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.back)
            isFrontCamera = !isFrontCamera
        }
        else{
            self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.front)
            isFrontCamera = !isFrontCamera
        }
    }
    
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        
        case .up:
            print("UP")
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
            break
        default:
            print("Default")
            break
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return number of items in room
        return totalItems.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else{
            fatalError("unable to deque cell")
        }
        cell.label.text = totalItems[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FinishScreenViewController{
            vc.timeRemained = timeLeft
        }
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

//extension GameViewController: UITableViewDataSource, UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return number of items in room
//        return EnviornmentModel.shared.getRemainingItemsWithRooms(room: self.room).count
//
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else{
//            fatalError("unable to deque cell")
//        }
//        cell.label.text = self.itemsToFound[indexPath.row]
//        return cell
//    }
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return 50
////    }
//
//
//}
