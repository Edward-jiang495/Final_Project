//
//  PlayerModel.swift
//  Final_project
//
//  Created by Jonathan Ebrahimian on 11/30/21.
//

import Foundation


class PlayerModel: NSObject {
    
    static let shared = PlayerModel();
    
    var scores: [String: Int] = [:];
    var completedRooms: Set<String> = [];
    var foundItems: Set<String> = [];
    
    var percentNotFound: Double
    {
        get
        {
            return Double(foundItems.count) / Double(EnvironmentModel.shared.objectCount)
        }
    }
    
    private override init()
    {
        super.init()
        
        UserDefaults.standard.register(
            defaults:
                [
                    "scores": scores,
                    "completedRooms": completedRooms,
                    "foundItems": foundItems,
                ]
        )
    }
    
    // MARK: UserDefaults
    
    private func saveDefaults()
    {
        UserDefaults.standard.set(scores, forKey: "scores")
        UserDefaults.standard.set(completedRooms, forKey: "completedRooms")
        UserDefaults.standard.set(foundItems, forKey: "foundItems")
    }
    
    private func loadDefaults()
    {
        scores = UserDefaults.standard.object(forKey: "scores") as! [String: Int]
        completedRooms = UserDefaults.standard.object(forKey: "completedRooms") as! Set<String>
        foundItems = UserDefaults.standard.object(forKey: "foundItems") as! Set<String>
    }
    
    func reset()
    {
        scores.removeAll()
        completedRooms.removeAll()
        foundItems.removeAll()
        
        saveDefaults()
    }
    
    // MARK: Object Tracking
    
    func findItem(item: String) -> Bool
    {
        let inserted = foundItems.insert(item).inserted
        
        if inserted
        {
            saveDefaults()
        }
        
        return inserted
    }
    
    func getMissedItems(room: String) -> [String]
    {
        let roomItems = EnvironmentModel.shared.locations[room]!
        
        var roomItemsSet = Set(roomItems)
        roomItemsSet.subtract(foundItems)
        
        return Array(roomItemsSet)
    }
    
    // MARK: Room Tracking
    
    func saveScore(room: String, score: Int)
    {
        // if oldScore is better, ignore
        if let oldScore = scores[room]
        {
            if score <= oldScore
            {
                return
            }
        }
        
        scores[room] = score
        saveDefaults()
    }
    
    func completeRoom(room: String) -> Bool
    {
        let inserted = completedRooms.insert(room).inserted
        
        if inserted
        {
            saveDefaults()
        }
        
        return inserted
    }
    
    //    var highScorePerRoom:[String:Int] = EnviornmentModel.shared.startingHighscores;
    //    var completedRooms:[String] = [];
    //    var itemsFound:[String:[String]] = EnviornmentModel.shared.startingItemsFound;
    //
    //
    //    private override init() {
    //        super.init();
    //        UserDefaults.standard.register(
    //            defaults: [
    //                "highScorePerRoom": EnviornmentModel.shared.startingHighscores,
    //                "completedRooms": [],
    //                "itemsFound": EnviornmentModel.shared.startingItemsFound
    //            ]
    //        );
    //        loadLocalStorage()
    //
    //
    //
    //    }
    //
    //    private func loadLocalStorage(){
    //        highScorePerRoom = UserDefaults.standard.object(forKey:"highScorePerRoom") as! [String : Int];
    //        completedRooms = UserDefaults.standard.object(forKey:"completedRooms") as! [String];
    //        itemsFound = UserDefaults.standard.object(forKey:"itemsFound") as! [String : [String]];
    //    }
    //
    //    func saveLocalStorage(){
    //        UserDefaults.standard.set(highScorePerRoom, forKey:"highScorePerRoom");
    //        UserDefaults.standard.set(completedRooms, forKey:"completedRooms");
    //        UserDefaults.standard.set(itemsFound, forKey:"itemsFound");
    //    }
    //
    //    func addFoundItem(room:String, itemFound:String){
    //       //add item if new
    //        var newroom = room.replacingOccurrences(of: "⭐", with: "")
    //        if !(itemsFound[newroom]?.contains(itemFound) ?? false) {
    //            itemsFound[newroom]?.append(itemFound);
    //            UserDefaults.standard.set(itemsFound, forKey:"itemsFound");
    //        }
    //    }
    //
    //    func saveRoomHighscore(room: String, newHighscore: Int){
    //        var newroom = room.replacingOccurrences(of: "⭐", with: "")
    //        highScorePerRoom[newroom] = newHighscore;
    //        UserDefaults.standard.set(highScorePerRoom, forKey:"highScorePerRoom");
    //    }
    //
    //    func saveRoomAsComplete(room: String){
    //        var newroom = room.replacingOccurrences(of: "⭐", with: "")
    //
    //        if !completedRooms.contains(newroom) {
    //            completedRooms.append(newroom);
    //            UserDefaults.standard.set(completedRooms, forKey:"completedRooms");
    //        }
    //    }
    //
    //    func resetPlayer(){
    //        highScorePerRoom = EnviornmentModel.shared.startingHighscores;
    //        completedRooms = [];
    //        itemsFound = EnviornmentModel.shared.startingItemsFound;
    //        UserDefaults.standard.removeObject(forKey:"highScorePerRoom");
    //        UserDefaults.standard.removeObject(forKey:"completedRooms");
    //        UserDefaults.standard.removeObject(forKey:"itemsFound");
    //
    //    }
    //
    //    func percentNotFound() -> Double{
    //        //change 100 to the total number of items that can be found
    //        var totalItemsFound = 0;
    //
    //        for (_,items) in itemsFound {
    //            totalItemsFound += items.count;
    //        }
    //
    //        var result = Double(totalItemsFound)/Double(EnviornmentModel.shared.numTotalItems) * 100
    ////        convert to percentage
    //        result = Double(round(100 * result) / 100);
    ////        coerce to 2 decimal place
    //        return result;
    //    }
    //
    //    func getHighScoreWithRoom(room:String) -> Int{
    //        var newroom = room.replacingOccurrences(of: "⭐", with: "")
    //
    //        return highScorePerRoom[newroom]!
    //    }
    //
    //    func getRemainingItemsWithRoom(room:String) ->[String]{
    //        var newroom = room.replacingOccurrences(of: "⭐", with: "")
    //
    //        var items = EnviornmentModel.shared.getItemsWithRoom(room: newroom)
    //        var itemsNotFound:[String] = []
    //        for element in items{
    //            if !(itemsFound[newroom]?.contains(element))!{
    //                itemsNotFound.append(element)
    //            }
    //        }
    //        return itemsNotFound
    //    }
    //
    //    func getStartingItemsFoundWithRoom(room: String) ->[String]{
    //        var newroom = room.replacingOccurrences(of: "⭐", with: "")
    //        return itemsFound[newroom]!
    //    }
    
    
}
