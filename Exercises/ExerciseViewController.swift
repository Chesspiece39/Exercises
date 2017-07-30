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
    
    var tempMuscle: String = ""
    
    var muscleArrays: [[String]] = [[String]]()
    
    var countArray: [String] = [String]()
    
    var row2: Int!
    
    var row: Int!
    
    
//MARK: Load data into the PickerView array.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Abs", "Arms", "Back", "Buttocks", "Cardio", "Chest", "Hips", "Legs", "Shoulders"]
        let absData = ["", "Abdominals", "Obliques", "Serratus anterior"]
        let armsData = ["", "Biceps", "Forearms", "Triceps"]
        let backData  = ["", "Erector spinae", "Infraspinatus", "Latissimus dorsi (Lats)", "Teres", "Trapezius"]
        let buttocksData = ["", "Gluteus maximus", "Gluteus medius"]
        let cardioData = ["", "Heart"]
        let chestData = ["", "Pectoralis major"]
        let hipsData = ["", "Hip adductors", "Hip Flexors", "Tensor fasciae latae"]
        let legsData = ["", "Calves", "Hamstrings", "Quads", "Sartorius", "Tibialis_anterior"]
        let shouldersData = ["", "Anterior delts", "Lateral delts", "Posterior delts"]
        
        muscleArrays = [absData, armsData, backData, buttocksData, cardioData, chestData, hipsData, legsData, shouldersData]

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
        return 2
    }
    
    // The number of rows of data
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        row = pickerView.selectedRow(inComponent: 0)
        
        if component == 0 {
            row2 = row
            return pickerData.count
        } else {
            countArray = getArrayForRow(row: row2)
            return countArray.count
        }
    }

//MARK: Load data into the pickerView
    
    internal func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
     {
        let pickerLabel = UILabel()
        if component == 0 {
            pickerLabel.text = pickerData[row]
        } else {
            pickerLabel.text = getArrayForRow(row: row2)[row]
            tempMuscle = pickerLabel.text!
        }
        pickerLabel.textColor = UIColor.black
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 13)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 14) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        
        return pickerLabel
     }
    


//MARK: Recycle pickerView to show second component.
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // This method is triggered whenever the user make a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        if component == 0 {
            row2 = row
            pickerView.reloadComponent(1)
        }

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
        if tempMuscle == "" {
            pickerMuscle = pickerData[row]
        } else {
            pickerMuscle = pickerData[row] + " / " + tempMuscle
        }
        
        // Set the exercise to be passed to ExerciseTableViewController after the unwind segue.
        
        exercise = Exercise(exerciseName: exerciseMachine!, muscleGroup: pickerMuscle)
    }
    
//MARK: Private Methods - Enable saveButton
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameExercise.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func getArrayForRow(row: Int) -> [String] {
        let tempArray = muscleArrays[row]
// print("tempArray = \(tempArray)")
            return tempArray
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
