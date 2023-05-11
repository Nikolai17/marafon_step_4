//
//  ViewController.swift
//  marafon_step4
//
//  Created by Nikolay Volnikov on 11.05.2023.
//

import UIKit

extension UITableView {
    enum Section {
        case main
    }
}

struct DiffModel: Hashable {
    var id: Int
}

class ViewController: UIViewController {

    var tableDataSource: UITableViewDiffableDataSource<UITableView.Section, DiffModel>!

    lazy var models: [DiffModel] = {
        var arr: [DiffModel] = []

        while arr.count < 50 {
            arr.append(DiffModel(id: arr.count))
        }

        return arr
    }()

    private var tableView: TableView

    required init?(coder: NSCoder) {
        self.tableView = TableView(style: .insetGrouped)

        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.layoutConstraints(in: view))
        tableView.layer.cornerRadius = 10
        // border
        tableView.layer.borderWidth = 0.3
        tableView.layer.borderColor = UIColor.black.cgColor

        // shadow
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 3, height: 3)
        tableView.layer.shadowOpacity = 0.7
        tableView.layer.shadowRadius = 4.0

        tableView.separatorInset = .zero
        tableView.directionalLayoutMargins = .zero
        tableView.layoutMargins = .zero
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let standardAppearance = UINavigationBarAppearance()

        // Title font color
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        // prevent Nav Bar color change on scroll view push behind NavBar
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .white

        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        configureNavBar()
        configureTableView()
        configureDataSource()
    }

    private func configureDataSource() {
        tableDataSource = UITableViewDiffableDataSource<UITableView.Section, DiffModel>(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
            cell.selectionStyle = .none
            cell.model = model

            return cell
        })
        updateSnapshot()

    }

    @objc private func shuffle() {
        models.shuffle()
        updateSnapshot()
    }
}

// MARK: - Private

fileprivate extension ViewController {

    func configureNavBar() {
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle))
    }

    func configureTableView() {
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemBackground
        tableView.register(CustomCell.self)
        tableView.delegate = self
    }

    func updateSnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<UITableView.Section, DiffModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        tableDataSource.defaultRowAnimation = .fade
        tableDataSource.apply(snapshot, animatingDifferences: animated)
    }

}


extension UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}

extension UITableView {

    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func reuse<T: UITableViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

open class TableView: UITableView {

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


extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temp = models[indexPath.row]
        models.remove(at: indexPath.row)
        models.insert(temp, at: 0)
        updateSnapshot()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        /// coming soon...
    }
}

public extension UITableView {

    func select(_ indexPaths: [IndexPath],
                animated: Bool = true,
                scrollPosition: UITableView.ScrollPosition = .none) {
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }


    func deselect(_ indexPaths: [IndexPath], animated: Bool = true) {
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }

    func deselectAll(animated: Bool = true) {
        deselect(indexPathsForSelectedRows ?? [], animated: animated)
    }

    func deselectAllInSection(except indexPath: IndexPath) {
        let indexPathsToDeselect = (indexPathsForSelectedRows ?? []).filter {
            $0.section == indexPath.section && $0.row != indexPath.row
        }
        deselect(indexPathsToDeselect)
    }
}

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
