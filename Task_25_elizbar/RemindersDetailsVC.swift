//
//  RemindersDetailsVC.swift
//  Task_25_elizbar
//
//  Created by alta on 8/24/22.
//

import UIKit
protocol RemindersDetailsVCProtocol {
    func DidSaveReminder()
}

class RemindersDetailsVC: UIViewController {
    
    var remiderPath = ""
    let manager = FileManager.default
    var delegate: RemindersDetailsVCProtocol?
    @IBOutlet weak var reminderBodyField: UITextField!
    @IBOutlet weak var reminderTitleField: UITextField!
    var reminderBody = ""
    var reminderTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminderBodyField.text = reminderBody
        reminderTitleField.text = reminderTitle
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        guard let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        if !reminderBodyField.text!.isEmpty && !reminderTitleField.text!.isEmpty{
            let reminderDirectoryUrl = documentsUrl.appendingPathComponent(remiderPath)
            let reminderUrl = reminderDirectoryUrl.appendingPathComponent("\(reminderTitleField.text!).txt")
            let data = Data(reminderBodyField.text!.utf8)
            manager.createFile(atPath: reminderUrl.path , contents: data)
            delegate?.DidSaveReminder()
            self.dismiss(animated: true)
        }
        if reminderTitle != reminderTitleField.text && reminderTitle != ""{
            let directoryUrl = getDocymentsUrl()
            let remindersDirectoruUrl = directoryUrl.appendingPathComponent(remiderPath)
            do {
                try manager.removeItem(at: remindersDirectoruUrl.appendingPathComponent("\(reminderTitle).txt"))
                delegate?.DidSaveReminder()
                self.dismiss(animated: true)
            }catch{
                print(error)
            }
        }
    }

}
