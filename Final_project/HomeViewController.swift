//
//  HomeViewController.swift
//  ARScavengerHunt
//
//  Created by Zhengran Jiang on 11/24/21.
//
//question to ask
//perform segue without buttn
//gesture detection with menu
//change table to a view 

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
//    lazy var playerModel = PlayerModel.shared
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
//    https://stackoverflow.com/questions/42144382/i-want-to-use-pickerview-in-segment-control-such-that-when-i-switch-segments-pic
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch difficulty.selectedSegmentIndex {
        case 0:
            return easyRooms.count
        case 1:
            return mediumRooms.count
        case 2:
            return hardRooms.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch difficulty.selectedSegmentIndex {
        case 0:
            return easyRooms[row]
        case 1:
            return mediumRooms[row]
        case 2:
            return hardRooms[row]
        default:
            return ""
        }
    }
    
    
    @IBAction func changeDifficulty(_ sender: UISegmentedControl) {
        self.room.reloadComponent(0)
    }
    
    var rooms: [String] = [String]()
    var easyRooms: [String] = [String]()
    var mediumRooms: [String] = [String]()
    var hardRooms: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.room.delegate = self
        self.room.dataSource = self
        easyRooms = EnviornmentModel.shared.getRoomWithDifficulty(diff: "easy")
        mediumRooms = EnviornmentModel.shared.getRoomWithDifficulty(diff: "medium")
        hardRooms = EnviornmentModel.shared.getRoomWithDifficulty(diff: "hard")
        var found = PlayerModel.shared.percentNotFound()
        self.setProgress(val:  Float(found))
        // Do any additional setup after loading the view.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         // This method is triggered whenever the user makes a change to the picker selection.
         // The parameter named row and component represents what was selected.
     }
    @IBOutlet weak var difficulty: UISegmentedControl!
    
  
    
    @IBOutlet weak var room: UIPickerView!
    
    
    @IBAction func start(_ sender: UIButton) {
//        start game
        print(difficulty.selectedSegmentIndex)
        var selectedValue = ""
        switch difficulty.selectedSegmentIndex {
        case 0:
            selectedValue = easyRooms[room.selectedRow(inComponent: 0)]
        case 1:
            selectedValue = mediumRooms[room.selectedRow(inComponent: 0)]
        case 2:
            selectedValue = hardRooms[room.selectedRow(inComponent: 0)]
        default:
            selectedValue = ""
        }
        
        print(selectedValue)
//        print selected room
        GameModel.shared.setRoom(room: selectedValue)
    

        
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
//        reset
//        add an alert box to warn players about reseting
        let alert = UIAlertController(title: "Reset Player?", message: "Upon clicking reset, all of your records be be erased. Are you sure about this? ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            switch action.style{
                case .default:
                PlayerModel.shared.resetPlayer()
                print("RESET")
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func setProgress(val: Float){
        self.progressBar.setProgress(val, animated: true)
        self.progressLabel.text = "Player's Progress: "+String(100*val)+"%"
    }
    

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
