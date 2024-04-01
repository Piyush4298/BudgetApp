//
//  BudgetCategoriesTableViewController.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 17/03/24.
//

import CoreData
import UIKit

class BudgetCategoriesTableViewController: UITableViewController {

    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgetCategory>
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = []
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init(nibName: nil, bundle: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BudgetCategoryTableViewCell.self, forCellReuseIdentifier: "BudgetCategoryTableViewCell")
        setUpUI()
    }

    private func setUpUI() {
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budgets"
    }
    
    private func deleteBudgetOf(category: BudgetCategory) {
        persistentContainer.viewContext.delete(category)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error Deleting the category: ", error.localizedDescription)
        }
    }
    
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetCategoryViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    // MARK: UITableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCategoryTableViewCell", for: indexPath)
                as? BudgetCategoryTableViewCell else {
            return BudgetCategoryTableViewCell(style: .default, reuseIdentifier: "BudgetCategoryTableViewCell")
        }
        cell.accessoryType = .disclosureIndicator
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        cell.configure(budgetCategory)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        
        self.navigationController?.pushViewController(BudgetDetailsViewController(persistentContainer: persistentContainer,
                                                                                  budgetCategory: budgetCategory),
                                                      animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let budgetCategory = fetchedResultsController.object(at: indexPath)
            deleteBudgetOf(category: budgetCategory)
        }
    }
}


extension BudgetCategoriesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


