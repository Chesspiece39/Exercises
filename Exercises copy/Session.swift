//
//  Session.swift
//  Exercises
//
//  Created by TBishop on 5/30/17.
//  Copyright © 2017 Chesspiece Consulting. All rights reserved.
//

import UIKit
import os.log

class Session: NSObject, NSCoding {
    
//MARK: Properties
    
    var exerciseName: String
    var sessionDate: String
    var sessionReps: String
    var sessionSets: String
    var sessionWeights: [String]
    
//MARK: Archiving Paths
    
    // Get URL to site directory. (ex. /Users/Ted/Sessions/...../Documents)
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    
    // Add new disk directory. (ex. /Users/Ted/Sessions/...../Documents/sessions)
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("sessions")
    
//MARK: Types
    
    struct PropertyKey {
        static let exerciseName = "name"
        static let sessionDate = "date"
        static let sessionReps = "rep"
        static let sessionSets = "set"
        static let sessionWeights = "weights"
    }
    
//MARK: Initialization
    
    init?(exerciseName: String, sessionDate: String, sessionReps: String, sessionSets: String, sessionWeights: [String]) {
        
        if exerciseName.isEmpty || sessionDate.isEmpty {
            return nil
        }
        //Initialize stored properties.
        self.exerciseName = exerciseName
        self.sessionDate = sessionDate
        self.sessionReps = sessionReps
        self.sessionSets = sessionSets
        self.sessionWeights = sessionWeights

    }
//MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(exerciseName, forKey: PropertyKey.exerciseName)
        aCoder.encode(sessionDate, forKey: PropertyKey.sessionDate)
        aCoder.encode(sessionReps, forKey: PropertyKey.sessionReps)
        aCoder.encode(sessionSets, forKey: PropertyKey.sessionSets)
        aCoder.encode(sessionWeights, forKey: PropertyKey.sessionWeights)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        
        guard let exerciseName = aDecoder.decodeObject(forKey: PropertyKey.exerciseName) as? String
            else {
                os_log("Unable to decode the name for an exercise object.", log: OSLog.default, type: .debug)
                return nil
        }
        let sessionDate = aDecoder.decodeObject(forKey: PropertyKey.sessionDate)
        let sessionReps = aDecoder.decodeObject(forKey: PropertyKey.sessionReps)
        let sessionSets = aDecoder.decodeObject(forKey: PropertyKey.sessionSets)
        let sessionWeights = aDecoder.decodeObject(forKey: PropertyKey.sessionWeights)
        
        // Must call designated initializer.
        
        self.init(exerciseName: exerciseName,
                  sessionDate: sessionDate as! String,
                  sessionReps: sessionReps as! String,
                  sessionSets: sessionSets as! String,
                  sessionWeights: sessionWeights as! [String])
    }

}










