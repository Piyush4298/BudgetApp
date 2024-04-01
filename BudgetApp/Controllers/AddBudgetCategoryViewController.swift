//
//  AddBudgetCategoryViewController.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 17/03/24.
//

import CoreData
import UIKit

class AddBudgetCategoryViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Budget Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Budget Amount"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var addBudgetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemTeal
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private var isFormValid: Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return false
        }
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(addBudgetButton)
        stackView.addArrangedSubview(errorMessageLabel)
        
        // Add Constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addBudgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        addBudgetButton.addTarget(self, action: #selector(addBudgetButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func addBudgetButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveBudgetCategory()
            errorMessageLabel.text = ""
        } else {
            errorMessageLabel.text = "Please fill the Name and Amount correctly."
        }
    }
    
    private func saveBudgetCategory() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {
            return
        }
        
        let budgetCategory = BudgetCategory(context: persistentContainer.viewContext)
        budgetCategory.name = name
        budgetCategory.amount = Double(amount) ?? 0.0
        
        do {
            try persistentContainer.viewContext.save()
            dismiss(animated: true)
        } catch {
            errorMessageLabel.text = "Unable to save budget category."
            print(error.localizedDescription)
        }
        
    }

}
