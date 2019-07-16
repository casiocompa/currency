//
//  SecondTableViewCell.swift
//  currency
//
//  Created by Ruslan Kasian on 7/13/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLableOutlet: UILabel!
    
    @IBOutlet weak var rateLableOutlet: UILabel!

    @IBOutlet weak var currencyLableOutlet: UILabel!
    
    var currencyRate: ToDateCurrencyExchangeRate? {
        didSet {
            configureView()
        }
    }
    
    var backgroundColorCell: UIColor = .white
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = currencyRate,
            let nameLable = nameLableOutlet,
            let rateLable = rateLableOutlet,
            let currencyLable = currencyLableOutlet,
            let fullName = detail.currencyFullName?.rawValue{
            nameLable.text = "\(fullName) (\(detail.currencyName))"
            rateLable.text = "\(format(number: detail.saleRateNB, f: ".2")) \(detail.baseCurrency.rawValue)"
            currencyLable.text = "1 \(detail.currencyName)"
          
        }
        
       self.backgroundColor =  backgroundColorCell
        
    }
    
    private func format(number: Double,f: String) -> String {
        return String(format: "%\(f)f", number)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if selected {
//            self.contentView.backgroundColor = .black
//        } else {
//            self.contentView.backgroundColor = .white
//        }
        
        // Configure the view for the selected state
    }

    
    
    
}
