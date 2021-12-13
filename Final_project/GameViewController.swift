import UIKit
import Vision
import AVFoundation
import CoreMedia
import VideoToolbox

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var room:String = GameModel.shared.getRoom();
    var itemsToFind:[String] = PlayerModel.shared.getRemainingItemsWithRoom(room: GameModel.shared.getRoom());
    var itemsFound:[String] = PlayerModel.shared.getStartingItemsFoundWithRoom(room: GameModel.shared.getRoom());
    var totalItems:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // YOLO Setup
        setUpBoundingBoxes()
        setUpCoreImage()
        setUpVision()
        setUpCamera()
        
        frameCapturingStartTime = CACurrentMediaTime()
        
        // Navigation
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Item Preparation
        totalItems = itemsToFind + itemsFound
        timeLeft = EnvironmentModel.shared.getTimeWithRooms(room: room)
        timerLabel.text = String(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
        var objToFind3 = ""
        if itemsToFind.count >= 3{
            //                more than three items to find
            let arrSlice = itemsToFind[0...2]
            objToFind3 = arrSlice.joined(separator:", ")
            
        }
        else{
            //                less than 3 items to find
            objToFind3 = itemsToFind.joined(separator:", ")
        }
        firstThreeObjectsToFind.text = objToFind3
        
        // table
        tableView.isScrollEnabled = true;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBOutlet weak var videoPreview: UIView!
    
    var timer: Timer?
    lazy var timeLeft = 10
    
    @IBOutlet weak var timerLabel: UILabel!
    
    // MARK: Game State
    
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
    
    // MARK: Detection Handling
    
    @IBAction func onDetectPress(_ sender: UIButton) {
        print("Detection requested.")
        detectionRequested = true
    }
    
    func onDetectedItems(_ items: [String])
    {
        for item in items
        {
            print("looking at \(item)")
            
            //            if let index = itemsToFind.firstIndex(of:item){
            //                let element = itemsToFind.remove(at: index)
            //                itemsFound.append(element)
            //                print("player newly found: \(element)")
            //            }
            //            PlayerModel.shared.addFoundItem(room: room, itemFound: item)
            //
            //            if let index = totalItems.firstIndex(of: item) {
            //                var element = totalItems.remove(at: index)
            //                element = element + "⭐"
            //                //            remove from beginning and append to the end
            //                //            WITH A STAR
            //                var objToFind3 = ""
            //                if itemsToFind.count >= 3{
            //                    //                more than three items to find
            //                    var arrSlice = itemsToFind[0...2]
            //                    objToFind3 = arrSlice.joined(separator:", ")
            //
            //                }
            //                else{
            //                    //                less than 3 items to find
            //                    objToFind3 = itemsToFind.joined(separator:", ")
            //                }
            //                firstThreeObjectsToFind.text = objToFind3
            //
            //                totalItems.append(element)
            //                tableView.reloadData()
            //                //            reload table
            //            }
        }
    }
    
    // MARK: Table Gestures
    @IBOutlet weak var firstThreeObjectsToFind: UITextView!
    
    var transparentView = UIView()
    var tableView = UITableView()
    var height:CGFloat = 250
    
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
    
    // MARK: YOLOv3
    
    let yolo = YOLO()
    
    var videoCapture: VideoCapture!
    var request: VNCoreMLRequest!
    var startTimes: [CFTimeInterval] = []
    
    var boundingBoxes = [BoundingBox]()
    
    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    var detectionRequested = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    // MARK: - YOLO Initialization
    
    func setUpBoundingBoxes() {
        print("Setting up bounding boxes...")
        
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
    }
    
    func setUpCoreImage() {
        print("Setting up CoreImage...")
        
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func setUpVision() {
        print("Setting up Vision...")
        
        guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
            print("Error: could not create Vision model")
            return
        }
        
        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        request.imageCropAndScaleOption = .scaleFill
    }
    
    func setUpCamera() {
        print("Setting up Camera...")
        
        videoCapture = VideoCapture()
        
        videoCapture.delegate = self
        videoCapture.fps = 60
        
        videoCapture.setUp(sessionPreset: AVCaptureSession.Preset.vga640x480) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.start()
            }
        }
    }
    
    // MARK: - UI stuff
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    // MARK: - Doing inference
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        print("Performing Vision Request...")
        
        // Measure how long it takes to predict a single video frame. Note that
        // predict() can be called on the next frame while the previous one is
        // still being processed. Hence the need to queue up the start times.
        startTimes.append(CACurrentMediaTime())
        
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        print("Vision Request Completed.")
        
        if let observations = request.results as? [VNCoreMLFeatureValueObservation] {
            let features = observations.map { $0.featureValue.multiArrayValue! }
            let boundingBoxes = yolo.computeBoundingBoxes(features: features)
            let elapsed = CACurrentMediaTime() - startTimes.remove(at: 0)
            
            onDetectedItems(boundingBoxes.map { labels[$0.classIndex] })
            print("Elapsed \(elapsed) seconds - \(self.measureFPS())")
        }
    }
    
    func measureFPS() -> Double {
        // Measure how many frames were actually delivered per second.
        framesDone += 1
        let frameCapturingElapsed = CACurrentMediaTime() - frameCapturingStartTime
        let currentFPSDelivered = Double(framesDone) / frameCapturingElapsed
        if frameCapturingElapsed > 1 {
            framesDone = 0
            frameCapturingStartTime = CACurrentMediaTime()
        }
        return currentFPSDelivered
    }
}

extension GameViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            if self.detectionRequested
            {
                self.predictUsingVision(pixelBuffer: pixelBuffer)
                self.detectionRequested = false
            }
        }
    }
}
