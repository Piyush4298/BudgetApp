//
//  BudgetCategoryTableViewCell.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 31/03/24.
//

import Foundation
import SwiftUI
import UIKit

class BudgetCategoryTableViewCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var totalAmountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var remainingAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0.5
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        // For Preview
        nameLabel.text = "Movie"
        totalAmountLabel.text = "1000"
        remainingAmountLabel.text = "200"
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .trailing
        verticalStack.addArrangedSubview(totalAmountLabel)
        verticalStack.addArrangedSubview(remainingAmountLabel)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(verticalStack)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    public func configure(_ budgetCategory: BudgetCategory) {
        nameLabel.text = budgetCategory.name
        totalAmountLabel.text = budgetCategory.amount.formatAsCurrency()
        remainingAmountLabel.text = "Remaining: \(budgetCategory.remainingAmount.formatAsCurrency())"
    }
}

struct BudgetCategoryTableViewCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        BudgetCategoryTableViewCell(style: .default, reuseIdentifier: "BudgetCategoryTableViewCell")
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

struct BudgetCategoryTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        BudgetCategoryTableViewCellRepresentable()
    }
}

