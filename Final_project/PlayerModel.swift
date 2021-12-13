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
                    "completedRooms": Array(completedRooms),
                    "foundItems": Array(foundItems),
                ]
        )
        
        loadDefaults()
    }
    
    // MARK: UserDefaults
    
    private func saveDefaults()
    {
        UserDefaults.standard.set(scores, forKey: "scores")
        UserDefaults.standard.set(Array(completedRooms), forKey: "completedRooms")
        UserDefaults.standard.set(Array(foundItems), forKey: "foundItems")
    }
    
    private func loadDefaults()
    {
        scores = UserDefaults.standard.object(forKey: "scores") as! [String: Int]
        completedRooms = Set(UserDefaults.standard.object(forKey: "completedRooms") as! [String])
        foundItems = Set(UserDefaults.standard.object(forKey: "foundItems") as! [String])
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
        let roomItems = EnvironmentModel.shared.itemsInLocation[room]!
        
        var roomItemsSet = Set(roomItems)
        roomItemsSet.subtract(foundItems)
        
        return Array(roomItemsSet)
    }
    
    // MARK: Room Tracking
    
    func saveScore(room: String, score: Int) -> Bool
    {
        // if oldScore is better, ignore
        if let oldScore = scores[room]
        {
            if score <= oldScore
            {
                return false
            }
        }
        
        scores[room] = score
        saveDefaults()
        
        return true
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
}
