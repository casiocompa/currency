//
//  ShowPopUp.swift
//  currency
//
//  Created by Ruslan Kasian on 7/16/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

class AlwaysPresentAsPopover : NSObject, UIPopoverPresentationControllerDelegate {
    
  
    private static let sharedInstance = AlwaysPresentAsPopover()
    
    private override init() {
        super.init()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    static func configurePresentation(forController controller : UIViewController) -> UIPopoverPresentationController {
        controller.modalPresentationStyle = .popover
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.delegate = AlwaysPresentAsPopover.sharedInstance
        return presentationController
    }
    
}
