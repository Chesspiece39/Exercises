//
//  SessionViewController.swift
//  Exercises
//
//  Created by TBishop on 5/23/17.
//  Copyright © 2017 Chesspiece Consulting. All rights reserved.
//

import UIKit
import os.log

class SessionViewController: UIViewController {
    

    
    
//MARK: Properties
    
    var stringPassed: String = "Anonymous"
    var tempDate: String = ""
    var sessions = [Session]()
    var clearArchive: Bool = false
    
    @IBOutlet var exerciseLabel: UITextField?
    
    @IBOutlet var dateField: UITextField!
    
    var reps: String = ""
    @IBOutlet var repsField: UITextField!
    
    var sets: String = ""
    @IBOutlet var setsField: UITextField!
    
    var weights: String = ""
    @IBOutlet var weightsField: UITextField!
    
    @IBOutlet var infoLabel: UILabel!
    
    @IBOutlet var lastDate: UITextField!
    
    @IBOutlet var lastReps: UITextField!
    
    @IBOutlet var lastSets: UITextField!
    
    @IBOutlet var lastWeights: UITextField!
    
//MARK: Activate cancel button.
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

//MARK: Load archived data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        
        // Load exercise and date fields
        loadData()
        setDate()
        
        // Read in archived data.
        if let savedSession = loadSession(){
            sessions += savedSession
            weights = ""

            for test in sessions {
                if test.exerciseName == stringPassed {
                    lastDate.text = test.sessionDate
                    lastReps.text = test.sessionReps
                    lastSets.text = test.sessionSets
                    weights = ""
                    for x in test.sessionWeights{
                        weights += (x + " ")
                    }
                    lastWeights.text = weights
                }
            }
        }
        
    }
/*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/    
    func checkNumeric(sample: String) -> Bool {
        let num = Int(sample)
        if num != nil {
            return true
        }
        else {
            return false
        }
    }

//MARK: Capture the data and check for legitimacy.
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
    // Catch and verify repetitions.
        
        reps = repsField.text!
        
        if checkNumeric(sample: reps) {
            infoLabel.text = ""
        } else {
            infoLabel.text = "Repetitions = \(reps) is not numeric. Please re-enter."
            return
        }
        
    // Catch and verify sets.

        sets = setsField.text!
        
        if checkNumeric(sample: sets) {
            infoLabel.text = ""
        } else {
            infoLabel.text = "Sets = \(sets) is not numeric. Please re-enter."
            return
        }
        
    //If both reps and sets are "0", set the clearArchive switch to true.
        
        if reps == "0" && sets == "0" {
            clearArchive = true
        }
        
    // Catch, parse and verify weights.
        
        weights = weightsField.text!
        var weightsArray = [String]()
        
        let tempArray = weights.components(separatedBy: " ")
        for x in tempArray {
            if checkNumeric(sample: x) {
                weightsArray.append(x)
            }
        }
        
        if weightsArray.count != Int(sets)! {
            infoLabel.text = "Please re-enter the weights separated by spaces."
        } else {
            infoLabel.text = ""
        }
        
    // Load Data into Session structure.
        
        if dateField.text != tempDate {
            tempDate = dateField.text!
        }
        
        let session = Session(exerciseName: stringPassed, sessionDate: tempDate, sessionReps: reps, sessionSets: sets, sessionWeights: weightsArray)
        sessions.append(session!)
        
    // Save sessions or erase all.
        
        if clearArchive != true {
            saveSessions()
        } else {
            sessions = []
            clearArchive = false
            saveSessions()
        }
    
        
        weightsArray = []
        
        goBackToTableViewController(SessionViewController.self)
        
    }
    
//MARK: Catch exercise name from ExerciseTableViewController
    
    func loadData() {
        exerciseLabel?.text = stringPassed
    }
    
//MARK: Format date and display it.
    
    func setDate() {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter() // Formerly NSDateFormatter
        var convertedDate = dateFormatter.string(from: currentDate as Date)
        dateFormatter.dateStyle = DateFormatter.Style.short
        convertedDate = dateFormatter.string(from: currentDate as Date)
        dateField.text = convertedDate
        tempDate = convertedDate
    }
    
//MARK: Load Session variables.
    
    func loadSessionVariables() {
    }
    
//MARK: Save session data to disk.
    
    private func saveSessions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(sessions, toFile: (Session.ArchiveURL?.path)!)
        if isSuccessfulSave {
            os_log("Sessions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save sessions...", log: OSLog.default, type: .error)
        }
    }

//MARK: Return to Table View Controller
    
    func goBackToTableViewController(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToExerciseTableViewController", sender: self)
    }
    
//MARK: Retrieve session data from disk.
    
    private func loadSession() -> [Session]? {
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: (Session.ArchiveURL?.path)!) as? [Session]
        
    }

}

//MARK: Keyboard Extensions

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

