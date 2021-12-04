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
        return currentRoom
    }
    func setRoom(room: String){
        currentRoom = room
    }

}
