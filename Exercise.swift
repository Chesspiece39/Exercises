//
//  Exercise.swift
//  Exercises
//
//  Created by TBishop on 5/17/17.
//  Copyright © 2017 Chesspiece Consulting. All rights reserved.
//

import UIKit
import os.log

class Exercise: NSObject, NSCoding {
    
    //MARK: Properties
    
    var exerciseName: String
    var muscleGroup: String
    
    //MARK: Archiving Paths
    
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("exercises")
    


    //MARK: Types
    
    struct PropertyKey {
        static let exerciseName = "name"
        static let muscleGroup = "group"
    }
    
    //MARK: Initialization
    
    init?(exerciseName: String, muscleGroup: String) {
        
        // Initialization should fail if there is no name.
        
        if exerciseName.isEmpty || muscleGroup.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup

    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(exerciseName, forKey: PropertyKey.exerciseName)
        aCoder.encode(muscleGroup, forKey: PropertyKey.muscleGroup)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        
        guard let exerciseName = aDecoder.decodeObject(forKey: PropertyKey.exerciseName) as? String
            else {
                os_log("Unable to decode the name for an exercise object.", log: OSLog.default, type: .debug)
                return nil
            }
        let muscleGroup = aDecoder.decodeObject(forKey: PropertyKey.muscleGroup)
        
        // Must call designated initializer.
        self.init(exerciseName: exerciseName, muscleGroup: muscleGroup as! String)
    }

}
