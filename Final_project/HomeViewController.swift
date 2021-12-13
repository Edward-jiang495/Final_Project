
import UIKit
import SpriteKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    let skview = SKView()
        
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
        addSnowAnimation()


//        let found = PlayerModel.shared.percentNotFound()
//        self.setProgress(val:  Float(found))
//
////        setting the font for ui segment control dynamically
////        why? because i dont know how to do it on the storyboard
//        let attr = NSDictionary(object: UIFont(name: "PWJoyeuxNoel", size: 18.0)!, forKey: NSAttributedString.Key.font as NSCopying)
//        UISegmentedControl.appearance().setTitleTextAttributes(attr as! [NSAttributedString.Key : Any] , for: [])
//        addSnowAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var completedRooms = PlayerModel.shared.completedRooms
        print(completedRooms)
        easyRooms = EnvironmentModel.shared.getRoomWithDifficulty(diff: "easy")
        mediumRooms = EnvironmentModel.shared.getRoomWithDifficulty(diff: "medium")
        hardRooms = EnvironmentModel.shared.getRoomWithDifficulty(diff: "hard")
        for element in completedRooms{
            let easyRoomIdx  = easyRooms.firstIndex(of: element)
            if easyRoomIdx != nil{
                easyRooms[easyRoomIdx!] = easyRooms[easyRoomIdx!] + "⭐"
            }
            let mediumRoomIdx = mediumRooms.firstIndex(of: element)
            if mediumRoomIdx != nil{
                mediumRooms[mediumRoomIdx!] = mediumRooms[mediumRoomIdx!] + "⭐"
            }
            let hardRoomIdx = hardRooms.firstIndex(of: element)
            if hardRoomIdx != nil{
                hardRooms[hardRoomIdx!] = hardRooms[hardRoomIdx!] + "⭐"
            }
        }
        self.room.reloadComponent(0)
            


        let attr = NSDictionary(object: UIFont(name: "PWJoyeuxNoel", size: 18.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as! [NSAttributedString.Key : Any] , for: [])
        let found = PlayerModel.shared.percentNotFound()
        self.setProgress(val:  Float(found))
        
        
    }
    
    
    
    

    
    func addSnowAnimation(){
        //create snowing animation
        let flakeEmitterCell = CAEmitterCell()
        flakeEmitterCell.contents = UIImage(named: "snowFlake")?.cgImage
        flakeEmitterCell.scale = 0.06
        flakeEmitterCell.scaleRange = 0.3
        flakeEmitterCell.emissionRange = .pi
        flakeEmitterCell.lifetime = 20.0
        flakeEmitterCell.birthRate = 20
        flakeEmitterCell.velocity = -30
        flakeEmitterCell.velocityRange = -20
        flakeEmitterCell.yAcceleration = 30
        flakeEmitterCell.xAcceleration = 5
        flakeEmitterCell.spin = -0.5
        flakeEmitterCell.spinRange = 1.0

        let snowEmitterLayer = CAEmitterLayer()
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        snowEmitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        snowEmitterLayer.beginTime = CACurrentMediaTime()
        snowEmitterLayer.timeOffset = 10
        snowEmitterLayer.emitterCells = [flakeEmitterCell]

        view.layer.addSublayer(snowEmitterLayer)
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
        
//        print(selectedValue)
//        print selected room
        GameModel.shared.setRoom(room: selectedValue)
        
    }
    
    
    @IBAction func reset(_ sender: UIButton) {
//        reset
//        add an alert box to warn players about reseting
        let alert = UIAlertController(title: "Reset Player?", message: "Upon clicking reset, all of your records be be erased. Are you sure about this? ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
            switch action.style{
                case .default:
                PlayerModel.shared.resetPlayer()
                self.setProgress(val: 0)
                for i in 0 ..< self.easyRooms.count {
                    easyRooms[i] = easyRooms[i].replacingOccurrences(of: "⭐", with: "", options: NSString.CompareOptions.literal, range: nil)
                }
                for i in 0 ..< self.mediumRooms.count {
                    mediumRooms[i] = mediumRooms[i].replacingOccurrences(of: "⭐", with: "", options: NSString.CompareOptions.literal, range: nil)
                }
                for i in 0 ..< self.hardRooms.count {
                    hardRooms[i] = hardRooms[i].replacingOccurrences(of: "⭐", with: "", options: NSString.CompareOptions.literal, range: nil)
                }
                self.room.reloadComponent(0)
                
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
        self.progressBar.setProgress(val/100.0, animated: true)
        self.progressLabel.text = "Progress: "+String(val) + "%"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "PWJoyeuxNoel", size: 18)
            pickerLabel?.textAlignment = .center
        }
        switch difficulty.selectedSegmentIndex {
        case 0:
            pickerLabel?.text = easyRooms[row]
            break
        case 1:
            pickerLabel?.text = mediumRooms[row]
            break
        case 2:
            pickerLabel?.text = hardRooms[row]
        default:
            break
        }
        pickerLabel?.textColor = UIColor.systemGreen

        return pickerLabel!
    }
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!


}
