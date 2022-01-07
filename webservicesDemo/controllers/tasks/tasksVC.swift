//
//  tasksVC.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/3/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit

class tasksVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]()
    
    lazy var Refresher : UIRefreshControl  = {
        let Refresher = UIRefreshControl()
        Refresher.addTarget(self, action: #selector(HandleRefresh), for: .valueChanged)
        
        return Refresher
    }()
    
    fileprivate let cellIdentifier = "TaskCell"
    fileprivate let cellHeight : CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tasks"
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.contentInset = .zero
        tableView.addSubview(Refresher)
        
        tableView.register(taskCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        let AddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:    #selector(HandleAdd))
        
        navigationItem.rightBarButtonItem = AddButton
        HandleRefresh()
    }
    
    @objc private func HandleAdd (){
        let alert = UIAlertController(title: "ADD New Item", message: "Enter Title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {
            $0.placeholder = "Title"
            $0.textAlignment = .center
            
            alert.addAction(UIAlertAction(title: "ADD", style: .destructive, handler: {(action : UIAlertAction) in
                guard let title = alert.textFields?.first?.text?.trimmed , !title.isEmpty else {return}
                
                // Send NEw Title To Server
                self.SendNewItemToServer(title: title)
            }))
            
        })
        self.present(alert, animated: true, completion: nil )
    }
    private func SendNewItemToServer (title : String){
        // Send Title To API
        print ("send title : \(title) To API")
        
        let newTask = Task(title: title)
        
        API.newTask(newtask : newTask)  { (error : Error? , tasks:Task?)in
            
            if let task = tasks  {
                // ADD IT TO MODEL
                self.tasks.insert(task, at: 0)
                //INSERT IT INTO TABLE VIEW
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                self.tableView.endUpdates()
                
            }
            
        }
        
        
    }
    
    var isLoading :Bool = false
    var current_page = 1
    var last_page = 1
    
    @objc  fileprivate func HandleRefresh (){
        self.Refresher.endRefreshing()
        guard  !isLoading else {return}
        isLoading = true
        
        API.tasks{(error :Error? , tasks: [Task]? ,last_page:Int) in
            self.isLoading = false
            if tasks != nil{
                self.tasks = tasks!
                
                self.tableView.reloadData()
                self.current_page = 1
                self.last_page = last_page
            }
        }
    }
    fileprivate func loadMore(){
        guard !isLoading else {return}
        guard current_page < last_page else {return}
        isLoading = true
        
        API.tasks(page : current_page + 1) {( error :Error? , tasks: [Task]?, lastPage :Int) in
            self.isLoading = false
            if let tasks = tasks{
                self.tasks.append(contentsOf: tasks)
                print (self.tasks)
                self.tableView.reloadData()
                self.current_page += 1
                
            }}
        
    }
}

extension tasksVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath ) as? taskCell else {
            return UITableViewCell ()
        }
        let task = tasks[indexPath.row]
        cell.configureCell(task: task)
              
        return cell
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
extension tasksVC: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.tasks.count
        
        if indexPath.row == count-1 {
            
            self.loadMore()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        let editedTask = task.copy() as! Task
        editedTask.completed = !editedTask.completed
        API.editTask(task: editedTask) { (error :Error?, finalTask:Task?) in
            if let finalTask = finalTask{
                // replace task with new task
                if let index = self.tasks.index(of : task ) {
                    self.tasks.remove(at: index)
                    self.tasks.insert(finalTask, at: index)
                    // refresh row
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                }else {
                    self.HandleRefresh()
                }
            }else {
                // show alert to user to try again
                let alert = UIAlertController(title: "OOOPS", message: "Sorry Uhave problem with connection , try again later 🙄", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let task = tasks[indexPath .row]
        
        let deleteAction = UITableViewRowAction (style: .default, title: "DELETE") {(action :UITableViewRowAction, indexpath :IndexPath) in
            self.handleDelete(task : task , indexPath:indexPath)
            
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UITableViewRowAction(style: .default, title: "EDIT") { (action :UITableViewRowAction,indexpath: IndexPath) in
            self.handleEdit(task : task , indexPath:indexPath)
        }
        
        editAction.backgroundColor = .lightGray
        return [deleteAction,editAction]
    }
    private func handleDelete (task : Task, indexPath :IndexPath){
        
        API.deleteTask(task: task) { (error:Error?, success : Bool) in
            if success {
                if let index = self.tasks.index(of : task){
                    self.tasks.remove(at: index)
                    //Remove Row
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.tableView.endUpdates()
                    
                }
            }else {
                // Show alert to user to try agian
            }
        }
        
    }
    private func handleEdit (task : Task, indexPath :IndexPath){
        
        
        let alert = UIAlertController(title: "Edit New Item", message: "Enter Title", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {
            $0.text = task.task
            $0.placeholder = "Title"
            $0.textAlignment = .center
            
            alert.addAction(UIAlertAction(title: "Edit", style: .destructive, handler: {(action : UIAlertAction) in
                guard let title = alert.textFields?.first?.text?.trimmed , !title.isEmpty else {return}
                
                // Send New Edited Title To Server
                
                let editTask = task.copy() as! Task
                editTask.task = title
                
                API.editTask(task: editTask, completion: { (error :Error?, editedTask :Task?) in
                    if let editedTask = editedTask{
                        // replace task with new task
                        if let index = self.tasks.index(of : task ) {
                            self.tasks.remove(at: index)
                            self.tasks.insert(editTask, at: index)
                        // refresh row
                            self.tableView.beginUpdates()
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            self.tableView.endUpdates()
                        }else {
                            self.HandleRefresh()
                        }
                    }else {
                        // show alert to user to try again
                         let alert = UIAlertController(title: "OOOPS", message: "Sorry Uhave problem with connection , try again later 🙄", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
                        
                    }
                })
            }))
        })
          self.present(alert, animated: true, completion: nil )
    }
}
