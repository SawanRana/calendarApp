//
//  ViewController.swift
//  CalenderCode
//
//  Created by SAWAN RANA RAMVEER SINGH on 13/03/22.
//

import UIKit
import FSCalendar
import CoreData

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, ToDoListProtocolMethods {
  
    private var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var hideCalendar: UIButton!
    @IBOutlet weak var calendarStackView: UIStackView!
    private var saveTaskToDelete: [Int:ToDoList] = [:]
    private var tagValue: Int = 0
    private var lastDate = Date()
    
    private let dateFormatter = DateFormatter()
    
    let grabPersistentViewContextFromAppDelegate =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var todoListItems: [ToDoList] = []
    private var updatedItems: [ToDoList] = []
    
    @IBAction func addTask(_ sender: Any) {
        let m = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = m.instantiateViewController(withIdentifier: "AddTaskView") as? AddTaskViewController {
            self.present(vc, animated: true, completion: {
                print("Displayed AddTaskViewController")
                vc.delegate = self
            })
        }
    }
    @IBAction func hideCalendarAction(_ sender: Any) {
        if let _ = hideCalendar.title(for: .normal)?.contains("Hide Calendar"), !calendarView.isHidden  {
            calendarView.isHidden = true
            hideCalendar.setTitle("Show Calendar", for: .normal)
            
        } else {
            calendarView.isHidden = false
            hideCalendar.setTitle("Hide Calendar", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "To Do List"
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "TasksSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TasksSectionHeaderView")
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
        hideCalendar.setTitle("Hide Calendar", for: .normal)
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 0.0, width: calendarView.frame.width - 30, height: calendarView.frame.height - 30))
        calendar.appearance.todayColor = .systemGreen
        calendar.appearance.selectionColor = .systemGreen
        calendarView.addSubview(calendar)
        view.addSubview(calendarStackView)
        calendar.dataSource = self
        calendar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        getAllItems()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else { fatalError() }
        let item = todoListItems[indexPath.row]
        _ = Locale.current
        dateFormatter.dateFormat = "dd MMM"
        let dateString = dateFormatter.string(from: item.date!)
        cell.configure(with: TableViewCellViewModel(date: dateString, task: item.task!))
        cell.b.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        cell.tag = tagValue
        cell.b.tag = tagValue
        saveTaskToDelete[tagValue] = item
        tagValue = tagValue + 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dequeFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TasksSectionHeaderView") as? TasksSectionHeaderView
        return dequeFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        SelectedDate.selectedDateFromCalendar = date
        _ = Locale.current
        dateFormatter.dateFormat = "dd MMM"
        let dS = dateFormatter.string(from: date)
        SelectedDate.selectedDate = dS
        if !dS.contains(dateFormatter.string(from: Date())) {
            lastDate = date
        } else {
            lastDate = date
        }
        getAllItems()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    // Core data
    
    func getAllItems() {
        do {
            var items = try grabPersistentViewContextFromAppDelegate.fetch(ToDoList.fetchRequest())
            if items.count > 1 {
                items = items.sorted(by: { $0.date! < $1.date! }) 
                self.updatedItems = items
            } else {
                self.updatedItems = items
            }
            
            self.todoListItems = updatedItems.filter({ $0.date! <= lastDate })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print(error)
        }
    }
    
    func createItem(task: String) {
        
        let item = ToDoList(context: grabPersistentViewContextFromAppDelegate)
        item.task = task
        if let sDFromCalendar = SelectedDate.selectedDateFromCalendar {
            item.date = sDFromCalendar
        } else {
            item.date = Date()
        }
        _ = Locale.current
        dateFormatter.dateFormat = "dd MMM"
        let dateString = dateFormatter.string(from: item.date!)
        let itemExist = todoListItems.filter { item in
            dateFormatter.string(from: item.date!).contains(dateString)
        }.first
        
        if let _ = itemExist {
            print("Task Already Exists")
            deleteItem(item: item)
        } else {
            // Now save this into core data base
            
            do {
                try grabPersistentViewContextFromAppDelegate.save()
                getAllItems()
            } catch {
                print(error)
            }
        }
    }
    
    func updateItem(item: ToDoList, task: String) {
        item.task = task
        item.date = Date()
        
        // Now save the core data
        do {
            try grabPersistentViewContextFromAppDelegate.save()
            getAllItems()
        } catch {
            print(error)
        }
    }
    
    func deleteItem(item: ToDoList) {
        grabPersistentViewContextFromAppDelegate.delete(item)
        
        // Now save the core data
        do {
            try grabPersistentViewContextFromAppDelegate.save()
            getAllItems()
        } catch {
            print(error)
        }
    }
    
    @objc func buttonPressed(sender: UIButton) {
        for key in saveTaskToDelete.keys {
            if key == sender.tag {
                deleteItem(item: saveTaskToDelete[key]!)
            }
        }
    }
}

