//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController {
    private lazy var weatherMainView: WeatherMainView = {
        let view = WeatherMainView()
        view.delegate = self
        view.popUpWindow.delegate = self
        return view
    }()
    
    override func loadView() {
        self.view = weatherMainView
        weatherMainView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherMainView.createMainView()
    }
}

extension WeatherMainViewController: WeatherMainViewDelegate {
    func testButtonPressed() {
//        weatherMainView.testView.layoutIfNeeded()
    }
    
    func locationButtonPressed() {
        print("Button pressed")
//        weatherMainView.addPopUpWindow()
    }
}

extension WeatherMainViewController: PopUpWindowDelegate {
    func animateFirst() {
        print("Tap")
        weatherMainView.animatePopUpWindowIn()
        }
    
    func animateSecond() {
        print("Hide")
        weatherMainView.animatePopUpWindowOut()
    }
}
