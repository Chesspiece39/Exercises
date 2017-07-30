//
//  ExerciseTableViewController.swift
//  Exercises
//
//  Created by TBishop on 5/17/17.
//  Copyright © 2017 Chesspiece Consulting. All rights reserved.
//

import UIKit
import os.log

class ExerciseTableViewController: UITableViewController {
    
//MARK: Properties
    
    var exercises = [Exercise]()
    var currentExercise: String = "Test"
    var exerciseExists : Bool = false
    
//MARK: Load the saved exercises into an array.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller. 
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved exercises, otherwise load sample data.
        if let savedExercises = loadExercises(){
            if savedExercises.isEmpty {
                loadSampleExercises()
            } else {
                exercises += savedExercises
            }
        } else {
            loadSampleExercises()
        }
    }

    /* Did receive memory warning - NOT USED
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
//MARK: Set up the table view's Sections, Rows and Cells.
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//MARK: Table view cells are reused and should be dequeued using a cell identifier.
        
        let cellIdentifier = "ExerciseTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExerciseTableViewCell
            else {
                fatalError("The dequeued cell is not an instance of ExerciseTableViewCell.")
        }
        
//MARK: Fetches the appropriate exercise for the data source layout and loads exerciseName and muscleGroup

        let exercise = exercises[indexPath.row]
        
        cell.exerciseLabel.text = exercise.exerciseName
        cell.muscleLabel.text = exercise.muscleGroup
        return cell
    }
    
//MARK: Override to support conditional editing of the table view.
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//MARK: Override to support editing the table view. (i.e. delete)
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveExercises()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

// MARK: - Segue Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    // Decide which scene to use for segue.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if segue.identifier == "ShowSession" {
                let exercise = exercises[indexPath.row]
                currentExercise = exercise.exerciseName
                let navVC = segue.destination as! UINavigationController
                let sessionVC = navVC.viewControllers.first as! SessionViewController
                sessionVC.stringPassed = currentExercise
            }
        }
        
    }

    
//MARK: Capture new cell information and load into exercises array.
    
    @IBAction func unwindToExerciseList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ExerciseViewController, let exercise = sourceViewController.exercise {
            
            // Add a new exercise
            
            let newIndexPath = IndexPath(row: exercises.count, section: 0)
        
//MARK: Check to see if muscle group has changed for existing exercise.
            
            for test in exercises {
                if test.exerciseName == exercise.exerciseName && test.muscleGroup != exercise.muscleGroup {
//                    print("test.exerciseName = \(test.exerciseName)")
//                    print("test.muscleGroup = \(test.muscleGroup)")
                    test.muscleGroup = exercise.muscleGroup
                    saveExercises()
                    exerciseExists = true
                }
            }
            if exerciseExists == true {
                tableView.reloadData()

                exerciseExists = false
            } else {
                exercises.append(exercise)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            
                // Save the exercises.
                saveExercises()
            }

        }
    }
    
//MARK: If there are no archived Exercises, load samples
    
    private func loadSampleExercises() {
        
        guard let exercise1 = Exercise(exerciseName: "Push-ups (Sample)", muscleGroup: "Biceps") else {
            fatalError("Unable to instantiate exercise1")
        }
        exercises += [exercise1]
        
        guard let exercise2 = Exercise(exerciseName: "Sit-ups (Sample)", muscleGroup: "Abs") else {
            fatalError("Unable to instantiate exercise1")
        }
        exercises += [exercise2]
    }
    
//MARK: Save exercise data to disk. 
    
    private func saveExercises() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(exercises, toFile: (Exercise.ArchiveURL?.path)!)
        if isSuccessfulSave {
            os_log("Exercises successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save exercises...", log: OSLog.default, type: .error)
        }
    }
    
//MARK: Retrieve exercise data from disk.
    
    private func loadExercises() -> [Exercise]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: (Exercise.ArchiveURL?.path)!) as? [Exercise]
        
    }
    
//MARK: Pass info to Exercise Status Scene
    
    private func passInfo() {
        let sessionViewController  = SessionViewController()
        sessionViewController.exerciseLabel?.text = "Gobbledigook"
        navigationController?.pushViewController(sessionViewController, animated: true)
    }
    
    @IBAction func unwindToExerciseTableViewController(segue:UIStoryboardSegue) {}

}

























