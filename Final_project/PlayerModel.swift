//
//  PlayerModel.swift
//  Final_project
//
//  Created by Jonathan Ebrahimian on 11/30/21.
//

import Foundation


class PlayerModel: NSObject {
    
    static let shared = PlayerModel();
    
    var highScorePerRoom:[String:Int] = EnviornmentModel.shared.startingHighscores;
    var completedRooms:[String] = [];
    var itemsFound:[String:[String]] = EnviornmentModel.shared.startingItemsFound;
    
    
    private override init() {
        super.init();
        UserDefaults.standard.register(
            defaults: [
                "highScorePerRoom": EnviornmentModel.shared.startingHighscores,
                "completedRooms": [],
                "itemsFound": EnviornmentModel.shared.startingItemsFound
            ]
        );
//        loadLocalStorage()
    
        
       
    }
    
    private func loadLocalStorage(){
        highScorePerRoom = UserDefaults.standard.object(forKey:"highScorePerRoom") as! [String : Int];
        completedRooms = UserDefaults.standard.object(forKey:"completedRooms") as! [String];
        itemsFound = UserDefaults.standard.object(forKey:"itemsFound") as! [String : [String]];
    }
    
    func saveLocalStorage(){
        UserDefaults.standard.set(highScorePerRoom, forKey:"highScorePerRoom");
        UserDefaults.standard.set(completedRooms, forKey:"completedRooms");
        UserDefaults.standard.set(itemsFound, forKey:"itemsFound");
    }
    
    func addFoundItem(room:String, itemFound:String){
       //add item if new
        if !(itemsFound[room]?.contains(itemFound) ?? false) {
            itemsFound[room]?.append(itemFound);
            UserDefaults.standard.set(itemsFound, forKey:"itemsFound");
        }
    }
    
    func saveRoomHighscore(room: String, newHighscore: Int){
        highScorePerRoom[room] = newHighscore;
        UserDefaults.standard.set(highScorePerRoom, forKey:"highScorePerRoom");
    }
    
    func saveRoomAsComplete(room: String){
        if !completedRooms.contains(room) {
            completedRooms.append(room);
            UserDefaults.standard.set(completedRooms, forKey:"completedRooms");
        }
    }
    
    func resetPlayer(){
        highScorePerRoom = EnviornmentModel.shared.startingHighscores;
        completedRooms = [];
        itemsFound = EnviornmentModel.shared.startingItemsFound;
        UserDefaults.standard.removeObject(forKey:"highScorePerRoom");
        UserDefaults.standard.removeObject(forKey:"completedRooms");
        UserDefaults.standard.removeObject(forKey:"itemsFound");
        
    }
    
    func percentNotFound() -> Double{
        //change 100 to the total number of items that can be found
        var totalItemsFound = 0;
        for (_,items) in itemsFound {
            totalItemsFound += items.count;
        }
        return Double(totalItemsFound)/Double(EnviornmentModel.shared.locations.keys.count);
    }
    
    
}
