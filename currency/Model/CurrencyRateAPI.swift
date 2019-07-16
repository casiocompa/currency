//
//  CurrencyRateAPI.swift
//  currency
//
//  Created by Ruslan Kasian on 7/13/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import Foundation

//enum CurrencyRateAPIResponseType:String {
//    case json = "json"
////    case xml = "xml"
//}

//enum CurrencyRateAPIResponseType:String {
//    case json = "json"
//    case xml = "xml"
//}

//enum CurrencyRateAPIProviderURL:String {
//    case privatbank = "https://api.privatbank.ua/p24api/"
//    case nbu = "nbu"
//}
//
//Наличный курс ПриватБанка (в отделениях):  КАКОЙ ИЗ НИХ?
//GET JSON: https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=3

//Наличный курс ПриватБанка (в отделениях):КАКОЙ ИЗ НИХ?
//GET JSON: https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5

//Безналичный курс ПриватБанка (конвертация по картам, Приват24, пополнение вкладов):
//GET JSON: https://api.privatbank.ua/p24api/pubinfo?exchange&json&coursid=11

//Архив курсов валют ПриватБанка, НБУ
//GET JSON: https://api.privatbank.ua/p24api/exchange_rates?json&date=13.07.2019



//Курсы валют, драгоценных металлов НБУ НЕРАБОТАЕТ!!!!!
//GET: https://privat24.privatbank.ua/p24/accountorder?oper=prp&PUREXML&apicour&country=ua


class CurrencyRateAPI {
    
    private let urlApiString:String = "https://api.privatbank.ua/p24api/exchange_rates?json&date="
    
    
    func read<T: Decodable>(to date: String, returning objectType: T.Type, completion: @escaping (T) -> Void){
        
        let urlString = String("\(urlApiString)\(date)")
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) {(data, response, err) in
            guard let data = data else {return}            
            do {
                let objectType = try JSONDecoder().decode(objectType.self, from: data)
                completion(objectType)
            }catch let jsonErr {
                print ("Error serialization json:",jsonErr)
            }
            }.resume()
        
    }
}
