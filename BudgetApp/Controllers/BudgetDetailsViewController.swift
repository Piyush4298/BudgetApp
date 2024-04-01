//
//  BudgetDetailsViewController.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 30/03/24.
//

import CoreData
import UIKit

class BudgetDetailsViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var budgetCategory: BudgetCategory
    private var fetchedResultsController: NSFetchedResultsController<Transaction>
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Transaction Amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.setTitle("Save Transaction", for: .normal)
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var budgetAmountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var totalTransactionAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    
    init(persistentContainer: NSPersistentContainer, budgetCategory: BudgetCategory) {
        self.persistentContainer = persistentContainer
        self.budgetCategory = budgetCategory
        
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                   managedObjectContext: persistentContainer.viewContext,
                                                                   sectionNameKeyPath: nil, 
                                                                   cacheName: nil)
        super.init(nibName: nil, bundle: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            errorMessageLabel.text = "Unable to fetch the Transactions!"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setTotalTransactionAmount()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = budgetCategory.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(budgetAmountLabel)
        stackView.setCustomSpacing(50, after: budgetAmountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(totalTransactionAmountLabel)
        stackView.addArrangedSubview(tableView)
        
        // Constraints
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveTransaction()
            errorMessageLabel.text = ""
        } else {
            errorMessageLabel.text = "Please fill the Name and Amount Correctly."
        }
    }
    
    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = Date()
        do {
            try persistentContainer.viewContext.save()
            resetForm()
            tableView.reloadData()
        } catch {
            errorMessageLabel.text = "Unable to save the transaction."
            print(error.localizedDescription)
        }
        
    }
    
    private func setTotalTransactionAmount() {
        totalTransactionAmountLabel.text = budgetCategory.totalTransactionAmount.formatAsCurrency()
    }
    
    private func resetForm() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        persistentContainer.viewContext.delete(transaction)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            errorMessageLabel.text = "Error while deleting the transaction!"
        }
    }
}

extension BudgetDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        let transaction = fetchedResultsController.object(at: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = transaction.name
        configuration.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let transaction = fetchedResultsController.object(at: indexPath)
            deleteTransaction(transaction)
        }
    }
}

extension BudgetDetailsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        setTotalTransactionAmount()
        tableView.reloadData()
    }
}
