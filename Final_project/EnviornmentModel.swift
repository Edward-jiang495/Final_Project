//
//  EnviornmentModel.swift
//  Final_project
//
//  Created by Jonathan Ebrahimian on 11/30/21.
//

import Foundation


//
//  PlayerModel.swift
//  Final_project
//
//  Created by Jonathan Ebrahimian on 11/30/21.
//

import Foundation


class EnviornmentModel: NSObject {
    
    static let shared = EnviornmentModel();
    
    let locations:[String:[String]] = [
        "personal room": ["person",
                        "backpack",
                        "handbag",
                        "luggage",
                        "bed",
                        "computer mouse",
                        "keyboard",
                        "computer",
                        "cell phone",
                        "books",
                        "teddy bear",
                        "toothbrush",
                        "hair dryer",],
        "living room": ["chair",
                        "potted plant",
                        "table",
                        "sofa",
                        "tv",
                        "tv controller",
                        "vase",
                        "clock"],
        "kitchen":["banana",
                    "broccoli",
                    "apple",
                    "orange",
                    "carrots",
                    "microwave",
                    "toaster",
                    "fridge",
                    "oven",
                    "sink",
                    "scissor"],
        "sports room":["frisbee",
                        "snowboard",
                        "kite",
                        "baseball glove",
                        "surf board",
                        "skis",
                        "football",
                        "soccer",
                        "baseball",
                        "baseball",
                        "skateboard",
                        "tennis racket"],
        "zoo":["birds",
                "dogs",
                "sheep",
                "elephant",
                "zebra",
                "cat",
                "horse",
                "cow",
                "bear",
                "giraffe"],
        "airport":["bike",
                    "motorcycle",
                    "bus",
                    "truck",
                    "car",
                    "airplane",
                    "train",
                    "sandwich",
                    "hotdog",
                    "donut",
                    "pizza",
                    "cake"]
    ];
    

    let difficulty:[String:[String]] = ["easy":["personal room","living room"],"medium":["kitchen","sports room"],"hard":["zoo","airport"]];
    
    let time:[String:Int] = ["personal room":100,"living room":100,"kitchen":100,"sports room":100,"zoo":100,"airport":100];
    
    let startingHighscores:[String:Int] =  ["personal room":0,"living room":0,"kitchen":0,"sports room":0,"zoo":0,"airport":0];
    
    let startingItemsFound:[String:[String]] = ["personal room":[],"living room":[],"kitchen":[],"sports room":[],"zoo":[],"airport":[]];
    
    var startingItemsNotFound:[String:[String]] = [
        "personal room": ["person",
                        "backpack",
                        "handbag",
                        "luggage",
                        "bed",
                        "computer mouse",
                        "keyboard",
                        "computer",
                        "cell phone",
                        "books",
                        "teddy bear",
                        "toothbrush",
                        "hair dryer",],
        "living room": ["chair",
                        "potted plant",
                        "table",
                        "sofa",
                        "tv",
                        "tv controller",
                        "vase",
                        "clock"],
        "kitchen":["banana",
                    "broccoli",
                    "apple",
                    "orange",
                    "carrots",
                    "microwave",
                    "toaster",
                    "fridge",
                    "oven",
                    "sink",
                    "scissor"],
        "sports room":["frisbee",
                        "snowboard",
                        "kite",
                        "baseball glove",
                        "surf board",
                        "skis",
                        "football",
                        "soccer",
                        "baseball",
                        "baseball",
                        "skateboard",
                        "tennis racket"],
        "zoo":["birds",
                "dogs",
                "sheep",
                "elephant",
                "zebra",
                "cat",
                "horse",
                "cow",
                "bear",
                "giraffe"],
        "airport":["bike",
                    "motorcycle",
                    "bus",
                    "truck",
                    "car",
                    "airplane",
                    "train",
                    "sandwich",
                    "hotdog",
                    "donut",
                    "pizza",
                    "cake"]
    ];
    
    
    
    
    private override init() {
        super.init();
    }
    
    func getRoomWithDifficulty(diff: String) -> [String]{
        return difficulty[diff]!
    }
    
    func getTimeWithRooms(room: String) ->Int {
        return time[room]!
    }
    
    func getHighScoreWithRooms(room: String) ->Int{
        return startingHighscores[room]!
    }
    
    func getRemainingItemsWithRooms(room: String) ->[String]{
        return startingItemsNotFound[room]!
    }

}
