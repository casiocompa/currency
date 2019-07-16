//
//  FirstCollectionViewCell.swift
//  currency
//
//  Created by Ruslan Kasian on 7/12/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit




class FirstCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate :  CurrentSelected?
    
    weak var mainVC: CollectionViewController?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var providerRateLableOutlet: UILabel!
    
    @IBOutlet weak var fetchDateLableOutlet: UILabel!
    
    
    
    
    var currencyCodeSecond: String? {
        didSet {
            setSelectedCell ()
        }
    }
    
    var fethDate: String? {
        didSet {
            fetchDateLableOutlet.text = fethDate
        }
    }
    
    var currencyRates: ToDateCurrenciesRatesStruct?  {
        didSet {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = currencyRates?.exchangeRatePB.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "firstTableCell", for: indexPath) as? FirstTableViewCell else {
            return UITableViewCell()
        }
        cell.currencyRate = currencyRates?.exchangeRatePB[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    delegate?.firstSelected(currencyRates?.exchangeRatePB[indexPath.row].currencyName)

 
    }
    
    func setSelectedCell (){
        if currencyCodeSecond != nil,
         let index = currencyRates?.exchangeRatePB.firstIndex(where: { $0.currencyName == currencyCodeSecond }){
            let path = IndexPath(row: index, section: 0)
            self.tableView.selectRow(at: path, animated: true, scrollPosition: .top)
        }
       
        
    }

    
    @IBAction func calendarButtonAction(_ sender: UIView) {
        let datePicker = UIDatePicker()//Date picker
        datePicker.frame = CGRect(x: 0, y: 0, width: 320, height: 216)
        datePicker.datePickerMode = .date
        datePicker.calendar = .current
        let currentDate = Date()
        let minimumDate = Calendar.current.date(byAdding: .year, value: -4, to: currentDate)
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = currentDate
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for:  .valueChanged)
        
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.white
        popoverView.addSubview(datePicker)
        // here you can add tool bar with done and cancel buttons if required
        
        let popoverViewController = UIViewController()
        popoverViewController.view = popoverView
        popoverViewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 216)
        popoverViewController.preferredContentSize = CGSize(width: 320, height: 216)
        self.mainVC?.showPopup(popoverViewController, sourceView: sender)
    
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fetchDateLableOutlet.text = fethDate
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        self.mainVC?.dismiss(animated: true, completion: nil)
        delegate?.fetchDate(formatDateToString(datePicker.date))
    }
    
    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
