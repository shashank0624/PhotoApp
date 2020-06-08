//
//  NavigationControllerExt.swift
//  PhotoApp
//
//  Created by Kirti Ahlawat on 07/06/20.
//  Copyright © 2020 Outect. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    
    public func hasViewController(ofKind kind: AnyClass) -> UIViewController?{
        return self.viewControllers.first(where: {$0.isKind(of: kind)})
    }
    
    public func hasViewController(ofKind kind : AnyClass) -> Bool{
        if let _ = self.viewControllers.first(where: {$0.isKind(of: kind.self)}){
            return true
        }else{
            return false
        }
    }
}
