//
//  CustomCell.swift
//  marafon_step4
//
//  Created by Nikolay Volnikov on 11.05.2023.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {

    var model: DiffModel?

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var contentConfig = defaultContentConfiguration().updated(for: state)
        contentConfig.text = "\(model?.id ?? 0)"
        contentConfig.imageProperties.tintColor = .systemBlue
        if state.isSelected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
        contentConfiguration = contentConfig
    }

}
