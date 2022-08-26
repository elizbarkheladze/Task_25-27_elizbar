//
//  RemindersVC.swift
//  Task_25_elizbar
//
//  Created by alta on 8/24/22.
//

import UIKit

func accesingfiles(path: String) ->[String] {
    let manager = FileManager.default
    var filesLastPaths = [String]()
    guard let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return ["nil"]
    }
    let filesDirectoryUrl = documentsUrl.appendingPathComponent(path)
    do{
        filesLastPaths = try manager.contentsOfDirectory(at: filesDirectoryUrl,includingPropertiesForKeys: nil).map{$0.lastPathComponent}
        
    }catch{
        print(error)
    }
    return filesLastPaths
    
}
func removefile(directoryPath: String,filepath:String){
    let manager = FileManager.default
    let directoryUrl = getDocymentsUrl()
    let reminderDirecoryUrl =  directoryUrl.appendingPathComponent(directoryPath)
    do {
        try manager.removeItem(at: reminderDirecoryUrl.appendingPathComponent("\(filepath)"))
    }catch{
        print(error)
    }
}

class RemindersVC: UIViewController {
    
    var reminders = [String]()
    var remindersPath = ""
    @IBOutlet weak var tableView: UITableView!
    let manager = FileManager.default
    override func viewDidLoad() {
        super.viewDidLoad()
        reminders = accesingfiles(path: remindersPath)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToDetails))
        // Do any additional setup after loading the view.
        print(remindersPath)
    }
    

    @objc func goToDetails() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersDetailsVC") as! RemindersDetailsVC
        vc.remiderPath = remindersPath
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    
    func getContentsOfTxtFile(index: Int) -> String{
        let documentsUrl = getDocymentsUrl()
        let remindersDirectory = documentsUrl.appendingPathComponent(remindersPath)
        let fileUrl = remindersDirectory.appendingPathComponent(reminders[index])
        do {
            return try String(contentsOf: fileUrl,encoding: .utf8)
        }catch{
            return "error"
        }
    }
}

extension RemindersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
        cell.reminderNameLabel.text = reminders[indexPath.row].replacingOccurrences(of: ".txt", with: "", options: NSString.CompareOptions.literal, range: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersDetailsVC") as! RemindersDetailsVC
        vc.remiderPath = remindersPath
        vc.reminderBody = getContentsOfTxtFile(index: indexPath.row)
        vc.reminderTitle = reminders[indexPath.row].replacingOccurrences(of: ".txt", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.navigationController?.present(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete {
            tableView.beginUpdates()
            LocalNotificationManager.setNotification(3, type: .seconds, repeats: false, title: "Reminder deleted", body: "Reminder '\(reminders[indexPath.row])' has been DELETED ", userInfo: ["aps":["Deleted":"Reminder"]])
            removefile(directoryPath: remindersPath, filepath: reminders[indexPath.row])
            reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
      }
}

extension RemindersVC : RemindersDetailsVCProtocol {
    func DidSaveReminder() {
        reminders = accesingfiles(path: remindersPath)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


