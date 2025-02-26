//
//  CountryDetailsViewController.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 25/02/2025.
//

import UIKit
import SwiftUI

class CountryDetailViewController: UIViewController {
    
    private let country: Country
    
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailView = CountryDetailView(country: country)
        let hostingController = UIHostingController(rootView: detailView)
        
        // Add as child VC
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
