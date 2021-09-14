//
//  ViewController.swift
//  PGAAppScheduler
//
//  Created by Fabian Cooper on 9/13/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    var appointments = [appointment]()
    @IBOutlet var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    
    @IBAction func didTapAdd() {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
            
        }
        vc.title = "New Appointment"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {name, details, date in
            
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = appointment(name: name, date: date, identifier: "id_\(name)")
                self.appointments.append(new)
                self.tableView.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = name
                content.sound = .default
                content.body = details
                
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    if error != nil {
                        print("Something is not right!")
                    }
                })
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapTest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler:{success, error in
            if success {
                self.scheduleTest()
            }
            else if error != nil {
                print("Error occured")
                
            }
        })
        
    }
    
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "Something Something"
        
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print("Something is not right!")
            }
        })
    }


}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appointments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = appointments[indexPath.row].name
        
        let date = appointments[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        cell.detailTextLabel?.text = formatter.string(from: date)
        
        return cell
    }

    
}

struct appointment {
    
    let name : String
    let date : Date
    let identifier : String
    
}


