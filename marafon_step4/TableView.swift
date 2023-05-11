//
//  TableView.swift
//  marafon_step4
//
//  Created by Nikolay Volnikov on 11.05.2023.
//

import Foundation
import UIKit

class TableView: UITableView {

    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)

        initialize()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        allowsMultipleSelection = true
    }

    func layoutConstraints(in view: UIView) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ]
    }
}

extension UITableView {
    
    enum Section {
        case main
    }
}
