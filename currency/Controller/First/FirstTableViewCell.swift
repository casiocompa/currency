//
//  FirstTableViewCell.swift
//  currency
//
//  Created by Ruslan Kasian on 7/13/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit
import Foundation

class FirstTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLableOutlet: UILabel!
    
    @IBOutlet weak var buyLableOutlet: UILabel!
    
    @IBOutlet weak var saleLableOutlet: UILabel!
    
    var currencyRate: ToDateCurrencyExchangeRate? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = currencyRate,
            let nameLable = nameLableOutlet,
            let buyLable = buyLableOutlet,
            let saleLable = saleLableOutlet,
            let buy = detail.purchaseRate,
            let sale = detail.saleRate {
            nameLable.text = detail.currencyName
            buyLable.text = format(number: buy,f: ".2")
            saleLable.text = format(number: sale,f: ".2")
        }
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

    }

}
