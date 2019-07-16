//
//  CurrencyStruct.swift
//  currency
//
//  Created by Ruslan Kasian on 7/13/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import Foundation




//https://api.privatbank.ua/p24api/exchange_rates?json&date=13.07.2019
// MARK: - ToDateCurrenciesRatesStruct
struct ToDateCurrenciesRatesStruct: Codable {
    let date: String
    let bank: String
    let baseCurrency: Int
    let baseCurrencyLit: BaseCurrency
    let exchangeRate: [ToDateCurrencyExchangeRate]
    let exchangeRatePB: [ToDateCurrencyExchangeRate]
    enum CodingKeys: String, CodingKey {
        case date
        case bank
        case baseCurrency
        case baseCurrencyLit
        case exchangeRate
    }
    
}

extension ToDateCurrenciesRatesStruct {
    
    init(from decoder: Decoder) throws {
        let contaner = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try contaner.decode(String.self, forKey: .date)
        self.bank = try contaner.decode(String.self, forKey: .bank)
        self.baseCurrency = try contaner.decode(Int.self, forKey: .baseCurrency)
        self.baseCurrencyLit = try contaner.decode(BaseCurrency.self, forKey: .baseCurrencyLit)
        let exchangeRateTemp = try contaner.decode([ToDateCurrencyExchangeRate].self, forKey: .exchangeRate)
        let exchangeRate = exchangeRateTemp.filter({ $0.currencyName != "isEmpty_Delete" })
        let exchangeRatePB = exchangeRate.filter({ $0.saleRate != nil })
        
        self.exchangeRate = exchangeRate.sorted(by:
            { $0.currencyName.localizedCaseInsensitiveCompare($1.currencyName) == .orderedAscending})
        self.exchangeRatePB = exchangeRatePB.sorted(by:
            {$0.mainSort > $1.mainSort})
//            {$0.currencyName.localizedCaseInsensitiveCompare($1.currencyName) == .orderedAscending})
    }
    
}

// MARK: - ExchangeRate
struct ToDateCurrencyExchangeRate: Codable {
    let currencyName: String
    let currencyFullName: CurrencyFullName?
    let baseCurrency: BaseCurrency
    let saleRateNB: Double
    let purchaseRateNB: Double   
    let saleRate: Double?
    let purchaseRate: Double?
    let mainSort: Int
    
    enum CodingKeys: String, CodingKey {
        case currencyName = "currency"
        case baseCurrency
        case saleRateNB
        case purchaseRateNB
        case saleRate
        case purchaseRate
    }
}

extension ToDateCurrencyExchangeRate {
    
    init(from decoder: Decoder) throws {
        let contaner = try decoder.container(keyedBy: CodingKeys.self)
        let currency = try? contaner.decode(String.self, forKey: .currencyName)
        
        self.currencyName = currency ?? "isEmpty_Delete"
        self.currencyFullName = try? contaner.decode(CurrencyFullName.self, forKey: .currencyName)
        if currencyName == "EUR" {
            self.mainSort = 3
        }else if currencyName == "USD" {
            self.mainSort = 2
        }else if currencyName == "RUB"{
            self.mainSort = 1
        }else {
            self.mainSort = 0
        }
        self.baseCurrency = try contaner.decode(BaseCurrency.self, forKey: .baseCurrency)
        self.saleRateNB = try contaner.decode(Double.self, forKey: .saleRateNB)
        self.purchaseRateNB = try contaner.decode(Double.self, forKey: .purchaseRateNB)
        self.saleRate = try? contaner.decode(Double.self, forKey: .saleRate)
        self.purchaseRate = try? contaner.decode(Double.self, forKey: .purchaseRate)
    }
}

enum BaseCurrency: String, Codable {
    case uah = "UAH"
}

enum CurrencyFullName: String, Codable, RawRepresentable {
    typealias RawValue = String

    case CAD
    case CNY
    case CZK
    case DKK
    case HUF
    case ILS
    case JPY
    case KZT
    case MDL
    case NOK
    case SGD
    case SEK
    case CHF
    case RUB
    case GBP
    case USD
    case UZS
    case BYN
    case TMT
    case AZN
    case TRY
    case EUR
    case UAH
    case GEL
    case PLZ
    case XAU
    case isEmpty_Delete

    
    var rawValue: RawValue {
        switch self {
        case .CAD: return "Канадский доллар"
        case .CNY: return "Китайский юань"
        case .CZK: return "Чешская крона"
        case .DKK: return "Датская крона"
        case .HUF: return "Венгерский форинт"
        case .ILS: return "Новый израильский шекель"
        case .JPY: return "Японская иена"
        case .KZT: return "Казахстанский тенге"
        case .MDL: return "Молдавский лей"
        case .NOK: return "Норвежская крона"
        case .SGD: return "Сингапурский доллар"
        case .SEK: return "Шведская крона"
        case .CHF: return "Швейцарский франк"
        case .RUB: return "Российский рубль"
        case .GBP: return "Британский фунт"
        case .USD: return "Доллар США"
        case .UZS: return "Узбекский сум"
        case .BYN: return "Белорусский рубль"
        case .TMT: return "Новый туркменский манат"
        case .AZN: return "Азербайджанский манат"
        case .TRY: return "Турецкая лира"
        case .EUR: return "Евро"
        case .UAH: return "Украинская гривна"
        case .GEL: return "Грузинский лари"
        case .PLZ: return "Польский злотый"
        case .XAU: return "Золото"
        default:
            return "isEmpty_Delete"
        }
    }
}





