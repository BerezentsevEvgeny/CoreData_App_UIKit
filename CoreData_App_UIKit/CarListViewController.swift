//
//  ViewController.swift
//  CoreData_App_UIKit
//
//  Created by Евгений Березенцев on 03.01.2022.
//

import UIKit

class CarListViewController: UITableViewController {
    
    private var carList: [Car] = []
    private let cellID = "cell"
    
    let context = StorageManager.shared.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        fetchData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func fetchData() {
        StorageManager.shared.fetch { result in
            switch result {
            case .success(let cars):
                carList = cars
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addCar(name: String, year: Int64) {
        StorageManager.shared.createCar(with: name, year: year)
        fetchData()
        let indexPath = IndexPath(row: carList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func configureNavBar() {
        title = "Car List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAlert))
    }
    
    @objc func presentAlert() {
        let alert = UIAlertController(title: "Enter car info", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Car name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Year"
        }
        guard let carName = alert.textFields?.first?.text, !carName.isEmpty else { return }
        guard let carYearText = alert.textFields?.last?.text, !carYearText.isEmpty, let carYear = Int64(carYearText) else { return }
        
        let okAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in

            self?.addCar(name: carName, year: carYear )
            self?.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }


}

extension CarListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        carList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let car = carList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = car.name
        content.secondaryText = String(describing: car.year)
        cell.contentConfiguration = content
        return cell
    }
}

