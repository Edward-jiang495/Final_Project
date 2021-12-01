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
    
    let locations:[String:[String]] = ["kitchen":[""]];
    let difficulty:[String:[String]] = ["easy":["kitchen"]];
    let time:[String:Int] = ["kitchen":100];
    let blankHighscores:[String:Int] = ["kitchen":100];
    
    
    private override init() {
        super.init();
        
    }
    

}
