//
//  GameModel.swift
//  Final_project
//
//  Created by Zhengran Jiang on 12/4/21.
//

import Foundation

class GameModel :NSObject {
    static let shared = GameModel();
    var currentRoom = ""
    
    private override init() {
        super.init()
    }
    
    func getRoom()->String{
        var newroom = currentRoom.replacingOccurrences(of: "⭐", with: "")
        return newroom
    }
    func setRoom(room: String){
        var newroom = room.replacingOccurrences(of: "⭐", with: "")
        currentRoom = newroom
    }

}
