//
//  Router.swift
//  MachineLearning
//
//  Created by anilk on 01/02/2020.
//  Copyright © 2020 anilk. All rights reserved.
//

import Foundation
import UIKit

public class Router {
    public class func getViewController(_ identifier: String) -> UIViewController {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: identifier)
    }
}
