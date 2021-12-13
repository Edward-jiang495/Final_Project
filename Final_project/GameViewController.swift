import UIKit
import Vision
import AVFoundation
import CoreMedia
import VideoToolbox

class GameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var transparentView = UIView()
    var tableView = UITableView()
    var height:CGFloat = 250
    var room:String = GameModel.shared.getRoom();
    var itemsToFind:[String] = PlayerModel.shared.getRemainingItemsWithRoom(room: GameModel.shared.getRoom());
    var itemsFound:[String] = PlayerModel.shared.getStartingItemsFoundWithRoom(room: GameModel.shared.getRoom());
    var totalItems:[String] = []
    
    var lastFoundItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBoundingBoxes()
        setUpCoreImage()
        setUpVision()
        setUpCamera()
        
        frameCapturingStartTime = CACurrentMediaTime()
        
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
    }
    
    @IBOutlet weak var videoPreview: UIView!
    
    
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
        for item in lastFoundItems
        {
            print("looking at \(item)")
            
            if let index = itemsToFind.firstIndex(of:item){
                let element = itemsToFind.remove(at: index)
                itemsFound.append(element)
                print("player newly found: \(element)")
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
        }
        //        the item that was found
        
        
    }
    
    
    
    //    @IBAction func toggleCamera(_ sender: UIButton) {
    //        if isFrontCamera{
    //            self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.back)
    //            isFrontCamera = !isFrontCamera
    //        }
    //        else{
    //            self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.front)
    //            isFrontCamera = !isFrontCamera
    //        }
    //    }
    
    
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
    
    let yolo = YOLO()
    
    var videoCapture: VideoCapture!
    var request: VNCoreMLRequest!
    var startTimes: [CFTimeInterval] = []
    
    var boundingBoxes = [BoundingBox]()
    var colors: [UIColor] = []
    
    let ciContext = CIContext()
    var resizedPixelBuffer: CVPixelBuffer?
    
    var framesDone = 0
    var frameCapturingStartTime = CACurrentMediaTime()
    let semaphore = DispatchSemaphore(value: 2)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    // MARK: - Initialization
    
    func setUpBoundingBoxes() {
        for _ in 0..<YOLO.maxBoundingBoxes {
            boundingBoxes.append(BoundingBox())
        }
        
        // Make colors for the bounding boxes. There is one color for each class,
        // 80 classes in total.
        for r: CGFloat in [0.2, 0.4, 0.6, 0.8, 1.0] {
            for g: CGFloat in [0.3, 0.7, 0.6, 0.8] {
                for b: CGFloat in [0.4, 0.8, 0.6, 1.0] {
                    let color = UIColor(red: r, green: g, blue: b, alpha: 1)
                    colors.append(color)
                }
            }
        }
    }
    
    func setUpCoreImage() {
        let status = CVPixelBufferCreate(nil, YOLO.inputWidth, YOLO.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create resized pixel buffer", status)
        }
    }
    
    func setUpVision() {
        guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
            print("Error: could not create Vision model")
            return
        }
        
        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        
        // NOTE: If you choose another crop/scale option, then you must also
        // change how the BoundingBox objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
    }
    
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 50
        videoCapture.setUp(sessionPreset: AVCaptureSession.Preset.vga640x480) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                //          // Add the bounding box layers to the UI, on top of the video preview.
                //          for box in self.boundingBoxes {
                //            box.addToLayer(self.videoPreview.layer)
                //          }
                
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
    
    func predict(image: UIImage) {
        if let pixelBuffer = image.pixelBuffer(width: YOLO.inputWidth, height: YOLO.inputHeight) {
            predict(pixelBuffer: pixelBuffer)
        }
    }
    
    func predict(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame.
        let startTime = CACurrentMediaTime()
        
        // Resize the input with Core Image to 416x416.
        guard let resizedPixelBuffer = resizedPixelBuffer else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let sx = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let sy = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
        let scaledImage = ciImage.transformed(by: scaleTransform)
        ciContext.render(scaledImage, to: resizedPixelBuffer)
        
        // This is an alternative way to resize the image (using vImage):
        //if let resizedPixelBuffer = resizePixelBuffer(pixelBuffer,
        //                                              width: YOLO.inputWidth,
        //                                              height: YOLO.inputHeight)
        
        // Resize the input to 416x416 and give it to our model.
        if let boundingBoxes = try? yolo.predict(image: resizedPixelBuffer) {
            let elapsed = CACurrentMediaTime() - startTime
            showOnMainThread(boundingBoxes, elapsed)
        }
    }
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Measure how long it takes to predict a single video frame. Note that
        // predict() can be called on the next frame while the previous one is
        // still being processed. Hence the need to queue up the start times.
        startTimes.append(CACurrentMediaTime())
        
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
           let features = observations.first?.featureValue.multiArrayValue {
            
            let boundingBoxes = yolo.computeBoundingBoxes(features: [features, features, features])
            let elapsed = CACurrentMediaTime() - startTimes.remove(at: 0)
            showOnMainThread(boundingBoxes, elapsed)
        }
    }
    
    func showOnMainThread(_ boundingBoxes: [YOLO.Prediction], _ elapsed: CFTimeInterval) {
        DispatchQueue.main.async {
            // For debugging, to make sure the resized CVPixelBuffer is correct.
            //var debugImage: CGImage?
            //VTCreateCGImageFromCVPixelBuffer(resizedPixelBuffer, nil, &debugImage)
            //self.debugImageView.image = UIImage(cgImage: debugImage!)
            
            self.show(predictions: boundingBoxes)
            
            let fps = self.measureFPS()
            print("Elapsed \(elapsed) seconds - \(fps)")
            
            self.semaphore.signal()
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
    
    func show(predictions: [YOLO.Prediction]) {
        lastFoundItems = []
        
        for i in 0..<boundingBoxes.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                // The predicted bounding box is in the coordinate space of the input
                // image, which is a square image of 416x416 pixels. We want to show it
                // on the video preview, which is as wide as the screen and has a 4:3
                // aspect ratio. The video preview also may be letterboxed at the top
                // and bottom.
                let width = view.bounds.width
                let height = width * 4 / 3
                let scaleX = width / CGFloat(YOLO.inputWidth)
                let scaleY = height / CGFloat(YOLO.inputHeight)
                let top = (view.bounds.height - height) / 2
                
                // Translate and scale the rectangle to our own coordinate system.
                var rect = prediction.rect
                rect.origin.x *= scaleX
                rect.origin.y *= scaleY
                rect.origin.y += top
                rect.size.width *= scaleX
                rect.size.height *= scaleY
                
                // Show the bounding box.
                let label = String(format: "%@ %.1f", labels[prediction.classIndex], prediction.score * 100)
                lastFoundItems.append(labels[prediction.classIndex])
                let color = colors[prediction.classIndex]
                boundingBoxes[i].show(frame: rect, label: label, color: color)
            } else {
                boundingBoxes[i].hide()
            }
        }
    }
}

extension GameViewController: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // For debugging.
        //predict(image: UIImage(named: "dog416")!); return
        
        semaphore.wait()
        
        if let pixelBuffer = pixelBuffer {
            // For better throughput, perform the prediction on a background queue
            // instead of on the VideoCapture queue. We use the semaphore to block
            // the capture queue and drop frames when Core ML can't keep up.
            DispatchQueue.global().async {
                self.predict(pixelBuffer: pixelBuffer)
                //self.predictUsingVision(pixelBuffer: pixelBuffer)
            }
        }
    }
}
