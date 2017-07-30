//
//  ExerciseViewController.swift
//  Exercises
//
//  Created by TBishop on 5/7/17.
//  Copyright © 2017 Chesspiece Consulting. All rights reserved.
//

import UIKit
import os.log

class ExerciseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
//MARK: Declare global components and StoryBoard connections.

    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameExercise: UITextField!

    
    var exercise: Exercise?
    
    var pickerData: [String] = [String]()
    
    var pickerMuscle: String = ""
    
    var muscleArrays: [[String]] = [[String]]()
    
    var row: Int?
    
//MARK: Load data into the PickerView array.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["", "Abs", "Arms", "Back", "Buttocks", "Cardio", "Chest", "Hips", "Legs", "Shoulders"]
/*        absData = ["", "Abdominals", "Obliques", "Serratus anterior"]
        armsData = ["", "Biceps", "Forearms", "Triceps"]
        backData  = ["", "Erector spinae", "Infraspinatus", "Latissimus dorsi (Lats)", "Teres", "Trapezius"]
        buttocksData = ["", "Gluteus maximus", "Gluteus medius"]
        cardioData = ["", "Heart"]
        chestData = ["", "Pectoralis major"]
        hipsData = ["", "Hip adductors", "Hip Flexors", "Tensor fasciae latae"]
        legsData = ["", "Calves", "Hamstrings", "Quads", "Sartorius", "Tibialis_anterior"]
        shouldersData = ["", "Anterior delts", "Lateral delts", "Posterior delts"]
        
        muscleArrays = [absData, armsData, backData, buttocksData, cardioData, chestData, hipsData, legsDate, shouldersData]
*/
    }
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
//MARK: Disable save button; Set up PickerView columns and rows.
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
//MARK: Set up PickerView # of components, # of rows and final muscle group selection
    
    // The number of components of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count    }
    
    // The data to return for the row and component (column) that's being passed in
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
//MARK: Capture the picker view selection.
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // This method is triggered whenever the user make a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        pickerMuscle = pickerData[row]
    }
    
//MARK: Navigation - Set up cancel button; Catch the save button for segue. Reload exercise array.
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let exerciseMachine = nameExercise.text
        
        // Set the exercise to be passed to ExerciseTableViewController after the unwind segue.
        
        exercise = Exercise(exerciseName: exerciseMachine!, muscleGroup: pickerMuscle)
    }
    
//MARK: Private Methods - Enable saveButton
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameExercise.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
