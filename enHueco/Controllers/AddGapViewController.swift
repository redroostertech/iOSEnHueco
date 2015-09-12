//
//  AddGapViewController.swift
//  enHueco
//
//  Created by Diego Gómez on 9/8/15.
//  Copyright © 2015 Diego Gómez. All rights reserved.
//

import UIKit

class AddGapViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var startHourDatePicker: UIDatePicker!
    @IBOutlet weak var endHourDatePicker: UIDatePicker!
    
    var editingGap : Gap?
    
    @IBAction func save(sender: UIButton)
    {
        if editingGap == nil
        {
            //editingGap?.startHour =
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dayPicker.dataSource = self
        self.dayPicker.delegate = self
        if editingGap != nil
        {
            //dayPicker.selectedRowInComponent()
            let cal = NSCalendar.currentCalendar()
            
            startHourDatePicker.setDate(cal.dateFromComponents(editingGap!.startHour)!, animated: true)
            
            endHourDatePicker.setDate(cal.dateFromComponents(editingGap!.endHour)!, animated: true)
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }

    // returns the # of rows in each component..
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return system.appUser.schedule.weekDays[row+2].weekDayName
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
