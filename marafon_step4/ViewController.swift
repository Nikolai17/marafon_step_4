//
//  ViewController.swift
//  marafon_step4
//
//  Created by Nikolay Volnikov on 11.05.2023.
//

import UIKit

struct DiffModel: Hashable {
    var id: Int
}

class ViewController: UIViewController {

    private var tableDataSource: UITableViewDiffableDataSource<UITableView.Section, DiffModel>!

    private lazy var models: [DiffModel] = {
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
        configureNavBar()
        configureTableView()
        configureDataSource()
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temp = models[indexPath.row]
        models.remove(at: indexPath.row)
        models.insert(temp, at: 0)
        updateSnapshot()
    }
}

// MARK: - Private

fileprivate extension ViewController {

    func configureNavBar() {
        let standardAppearance = UINavigationBarAppearance()

        // Title font color
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        // prevent Nav Bar color change on scroll view push behind NavBar
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = .white

        self.navigationController?.navigationBar.standardAppearance = standardAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffle))
    }

    func configureTableView() {
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

    @objc func shuffle() {
        models.shuffle()
        updateSnapshot()
    }

    func configureDataSource() {
        tableDataSource = UITableViewDiffableDataSource<UITableView.Section, DiffModel>(tableView: tableView, cellProvider: { tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
            cell.selectionStyle = .none
            cell.model = model

            return cell
        })
        updateSnapshot()
    }
}
