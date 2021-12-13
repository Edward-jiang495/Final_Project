
import UIKit
import SpriteKit

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    let skview = SKView()
    
    //    var rooms: [String] = [String]()
    //    var easyRooms: [String] = [String]()
    //    var mediumRooms: [String] = [String]()
    //    var hardRooms: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.room.delegate = self
        self.room.dataSource = self
        
        addSnowAnimation()
        
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateViews()
    }
    
    func updateViews() {
        let attr = NSDictionary(object: UIFont(name: "PWJoyeuxNoel", size: 18.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes((attr as! [NSAttributedString.Key : Any]) , for: [])
        
        let found = PlayerModel.shared.percentNotFound
        self.progressBar.setProgress(Float(found), animated: true)
        self.progressLabel.text = "Progress: " + String(PlayerModel.shared.foundItems.count) +  " / " + String(EnvironmentModel.shared.objectCount) + " Items Found..."
        
        room.reloadComponent(0)
    }
    
    // MARK: Picker
    
    @IBOutlet weak var room: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EnvironmentModel.shared.roomsInDifficulty[
            EnvironmentModel.shared.difficulties[difficulty.selectedSegmentIndex]
        ]!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let roomName = EnvironmentModel.shared.roomsInDifficulty[
            EnvironmentModel.shared.difficulties[difficulty.selectedSegmentIndex]
        ]![row]
        print(roomName)
        if PlayerModel.shared.completedRooms.contains(roomName)
        {
            return "⭐️ " + roomName
        }
        
        else
        {
            return roomName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "PWJoyeuxNoel", size: 18)
            pickerLabel?.textAlignment = .center
        }
        
        let roomName = EnvironmentModel.shared.roomsInDifficulty[
            EnvironmentModel.shared.difficulties[difficulty.selectedSegmentIndex]
        ]![row]

        if PlayerModel.shared.completedRooms.contains(roomName)
        {
            pickerLabel?.text = "⭐️ " + roomName
        }
        
        else
        {
            pickerLabel?.text = roomName
        }
        
        pickerLabel?.textColor = UIColor.systemGreen
        
        return pickerLabel!
    }
    
    // MARK: Segmented Control
    
    @IBOutlet weak var difficulty: UISegmentedControl!
    
    @IBAction func changeDifficulty(_ sender: UISegmentedControl) {
        self.room.reloadComponent(0)
    }
    
    // MARK: Progress Bar
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: Snow Animation
    
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
    
    // MARK: Buttons
    
    @IBAction func start(_ sender: UIButton) {
        
        let selectedRoom: String = EnvironmentModel.shared.roomsInDifficulty[
            EnvironmentModel.shared.difficulties[difficulty.selectedSegmentIndex]
        ]![room.selectedRow(inComponent: 0)]
        
        print("Starting room: \(selectedRoom)")
        GameModel.shared.currentRoom = selectedRoom
    }
    
    // TODO: FINISH ME
    @IBAction func reset(_ sender: UIButton) {
        //        reset
        //        add an alert box to warn players about reseting
        let alert = UIAlertController(title: "Reset Player?", message: "Upon clicking reset, all of your records be be erased. Are you sure about this? ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] action in
            switch action.style{
            case .default:
                PlayerModel.shared.reset()
                self.updateViews()
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
}
