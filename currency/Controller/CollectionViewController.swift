//
//  MainCollectionViewController.swift
//  currency
//
//  Created by Ruslan Kasian on 7/12/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

protocol CurrentSelected: class {
    func firstSelected(_ code: String?)
    func secondSelected(_ code: String?)
    func fetchDate(_ date: String)
    
}

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CurrentSelected {
    func firstSelected(_ code: String?) {
        currencyCodeFirst = code
        currencyCodeSecond = nil
    }
    
    func secondSelected(_ code: String?) {
        currencyCodeSecond = code
        currencyCodeFirst = nil
    }
    
    func fetchDate(_ date: String) {
        if self.fethDate != date {
            fethDate = date
        }        
    }
    
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    let fadeView:UIView = UIView()
    
    private var currenciesRates: ToDateCurrenciesRatesStruct?
    
    private var currencyCodeFirst: String? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var currencyCodeSecond: String? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var fethDate: String = "" {
        didSet{
            fetchingData (date: fethDate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView ()
        fethDate = today()
    }
    
    func setupView () {
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .always
        }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layoutIfNeeded()
        if orientation (),
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.invalidateLayout()
        } else if !orientation (),
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.invalidateLayout()
        }
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func orientation () -> Bool{
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait {
            return true
            //Portrait orientation
        } else if orientation == .landscapeRight || orientation ==
            .landscapeLeft{
             //Landscape orientation
            return false
        }
        return false
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCollectionViewCell", for: indexPath) as? FirstCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.mainVC = self
            cell.currencyRates = currenciesRates
            cell.currencyCodeSecond = currencyCodeSecond
            cell.fethDate = fethDate
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCollectionViewCell", for: indexPath) as? SecondCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.mainVC = self
            cell.currencyRates = currenciesRates
            cell.currencyCodeFirst = currencyCodeFirst
            cell.fethDate = fethDate
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orientation () {
            let width = view.frame.size.width
            let height = view.frame.size.height
            if indexPath.row == 0 {
                return CGSize(width: width - 16, height: 195)
            }
            else {
                if UIScreen.main.nativeBounds.height > 2435 {
                    return CGSize(width: width - 16, height: height - 195 - 44 - 54 - 22)
                }else {
                    return CGSize(width: width - 16, height: height - 195 - 44 - 22)
                }
            }
        } else  {
            var width = view.frame.size.width/2
            var height = view.frame.size.height - 44
            if UIScreen.main.nativeBounds.height > 2435 {
                width = width - 44
                height = height - 22
            }
            return CGSize(width: width, height: height)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.layoutIfNeeded()
        if orientation (),   //Portrait orientation
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.invalidateLayout()
        } else if orientation (), ///Landscape orientation
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.invalidateLayout()
        }
    }
    
    func fetchingData (date: String) {
        startSpiner ()
        CurrencyRateAPI().read(to: date, returning: ToDateCurrenciesRatesStruct.self, completion: { (object) in
            DispatchQueue.main.async {
                self.currenciesRates = object
                self.stopSpiner ()
                self.collectionView.reloadData()
            }
        })
    }
    
    private func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    private func today()-> String {
        return self.formatDateToString (Date())
    }
    
    func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    func startSpiner () {
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.4
        
        self.view.addSubview(fadeView)
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        activityView.startAnimating()
    }
    
    func stopSpiner () {
        self.collectionView?.alpha = 1
        self.fadeView.removeFromSuperview()
        self.activityView.stopAnimating()
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        fetchingData (date: fethDate)
    }
}
