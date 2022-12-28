//
//  TableViewCell.swift
//  CalenderCode
//
//  Created by SAWAN RANA RAMVEER SINGH on 13/03/22.
//

import Foundation
import UIKit

struct TableViewCellViewModel {
    let date: String
    let task: String
}

class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "TableViewCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let b: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(taskLabel)
        self.contentView.addSubview(b)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.width/2, height: contentView.frame.height/2)
        
        taskLabel.frame = CGRect(x: 10, y: contentView.frame.height/2, width: contentView.frame.width/2, height: contentView.frame.height/2)
        
        b.frame = CGRect(x: contentView.frame.width - 50, y: 20, width: contentView.frame.width/10 , height: contentView.frame.height/2)
        b.layer.cornerRadius = 20
    }
    
    func configure(with viewModel: TableViewCellViewModel) {
        dateLabel.text = viewModel.date
        taskLabel.text = viewModel.task
    }
    
}
