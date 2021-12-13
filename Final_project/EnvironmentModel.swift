

import Foundation


class EnvironmentModel: NSObject {
    
    static let shared = EnvironmentModel();
    
    // MARK: Locations & Objects
    
    var objectCount: Int {
        get {
            let counts = locations.map {$0.value.count}
            return counts.reduce(0, +)
        }
    }
    
    let locations: [String: [String]] =
    [
        "bedroom":
            [
                "person",
                "backpack",
                "handbag",
                "suitcase",
                "bed",
                "mouse",
                "keyboard",
                "cell phone",
                "book",
                "teddy bear",
                "hair drier",
            ],
        
        "living room":
            [
                "chair",
                "pottedplant",
                "diningtable",
                "sofa",
                "tvmonitor",
                "remote",
                "vase",
                "clock",
            ],
        
        "kitchen":
            [
                "banana",
                "broccoli",
                "apple",
                "orange",
                "carrot",
                "microwave",
                "toaster",
                "refrigerator",
                "oven",
                "sink",
                "scissors",
            ],
        
        "gymnasium":
            [
                "frisbee",
                "snowboard",
                "kite",
                "baseball glove",
                "baseball bat",
                "surfboard",
                "skis",
                "sports ball",
                "skateboard",
                "tennis racket",
            ],
        
        "zoo":
            [
                "bird",
                "dog",
                "sheep",
                "elephant",
                "zebra",
                "cat",
                "horse",
                "cow",
                "bear",
                "giraffe",
            ],
        
        "airport":
            [
                "bicycle",
                "motorbike",
                "bus",
                "truck",
                "car",
                "aeroplane",
                "train",
                "sandwich",
                "hot dog",
                "donut",
                "pizza",
                "cake",
            ],
    ]
    
    let humanReadable: [String: String] =
    [
        "mouse": "computer mouse",
        "hair drier": "hair dryer",
        "pottedplant": "potted plant",
        "tvmonitor": "TV / monitor",
        "remote": "TV remote",
        "aeroplane": "airplane",    // uk english is not human readable, lol (kidding)
        "motorbike": "motorcycle",
    ]
    
    
    func getHumanReadable(object: String) -> String {
        var output = object
        
        if let corrected = humanReadable[object]
        {
            output = corrected
        }
        
        return output.uppercased()
    }
    
    // MARK: Timing
    
    let times: [String: Int] =
    [
        "bedroom": 100,
        "living room": 100,
        "kitchen": 100,
        "gymnasium": 150,
        "zoo": 300,
        "airport": 250,
    ]
    
    // MARK: Difficulty
    
    let difficulties: [String: [String]] =
    [
        "easy": ["bedroom", "living room"],
        "medium": ["kitchen", "gymnasium"],
        "hard": ["zoo", "airport"],
    ]
}
