//
//  SecondCollectionViewCell.swift
//  currency
//
//  Created by Ruslan Kasian on 7/12/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    

    
    weak var delegate : CurrentSelected?
    
    weak var mainVC: CollectionViewController?
   
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var providerRateLableOutlet: UILabel!
    
    @IBOutlet weak var fetchDateLableOutlet: UILabel!
    
    
    
    var currencyCodeFirst: String? {
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
            guard let count = currencyRates?.exchangeRate.count else {
                return 0
            }
            
            return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "secondTableCell", for: indexPath) as? SecondTableViewCell else {
                return UITableViewCell()
            }
            cell.currencyRate = currencyRates?.exchangeRate[indexPath.row]
            if indexPath.row%2 != 0 {
               cell.backgroundColor = UIColor.init(named: "cellStriping")
            }
            return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.secondSelected(currencyRates?.exchangeRate[indexPath.row].currencyName)
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.tableFooterView = UIView(frame: .zero)
        fetchDateLableOutlet.text = fethDate
        
    }
    
    func setSelectedCell (){
        
        if currencyCodeFirst != nil,
            let index = currencyRates?.exchangeRate.firstIndex(where: { $0.currencyName == currencyCodeFirst }){
            let path = IndexPath(row: index, section: 0)
            self.tableView.selectRow(at: path, animated: true, scrollPosition: .top)
        }
    }
    
  
 
    
    
    @IBAction func calendarButtonAction(_ sender: UIView) {
   
        let datePicker = UIDatePicker()//Date picker
        datePicker.frame = CGRect(x: 0, y: 0, width: 320, height: 216)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for:  .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.calendar = .current
        let currentDate = Date()
        let minimumDate = Calendar.current.date(byAdding: .year, value: -4, to: currentDate)
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = currentDate
        
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
