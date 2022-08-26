//
//  ViewController.swift
//  Task_25_elizbar
//
//  Created by alta on 8/24/22.
//

import UIKit
func getDocymentsUrl() -> URL{
    let manager = FileManager.default
    guard let documentsUrl = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return URL(string: "error")!
    }
    return documentsUrl
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let manager = FileManager.default
    var allDirectories  = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createDirectory))
        accesingDirectories()
        // Do any additional setup after loading the view.
    }
    func accesingDirectories() {
        let documentsUrl = getDocymentsUrl()
        do{
            allDirectories = try manager.contentsOfDirectory(at: documentsUrl,includingPropertiesForKeys: nil).map{$0.lastPathComponent}
            
        }catch{
            print(error)
        }
        
        
    }
    @objc func createDirectory(){
        let alert = UIAlertController(title: "Add", message: "create DIrectory", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: { _ in
            guard let fields = alert.textFields else{
                return
            }
            let directoryNameField = fields[0]
            guard let directryName = directoryNameField.text , !directryName.isEmpty else {
                return
            }
            guard let documentsUrl = self.manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let directoryPath = documentsUrl.appendingPathComponent("\(directryName)")
            do{
                try self.manager.createDirectory(at: directoryPath, withIntermediateDirectories: true)
                self.accesingDirectories()
                LocalNotificationManager.setNotification(3, type: .seconds, repeats: false, title: "New Directory", body: "Directory '\(directryName)' has been added ", userInfo: ["aps":["New":"Directory"]])
                
            }catch{
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        present(alert,animated: true)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allDirectories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectoryCell",for: indexPath) as! DirectoryCell
        cell.directpryNameLbl.text = allDirectories[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersVC") as! RemindersVC
        vc.remindersPath = allDirectories[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
