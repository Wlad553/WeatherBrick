//
//  Created by Volodymyr Andriienko on 11/3/21.
//  Copyright © 2021 VAndrJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var brickImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var infoView: InfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.alpha = 0
        setUpInfoButtonDesign()
        
        infoButton.addTarget(self, action: #selector(showOrDismissInfoView), for: .touchUpInside)
        infoView.hideButton.addTarget(self, action: #selector(showOrDismissInfoView), for: .touchUpInside)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchView = touches.first?.view else { return }
        
        if touchView != infoView.contentView && infoView.alpha == 1 {
            showOrDismissInfoView()
        }
    }
    
    @objc func showOrDismissInfoView() {
        
        if infoView.alpha == 0 {
            UIView.animate(withDuration: 0.15) {
                self.contentView.alpha = 0.5
                self.infoView.alpha = 1
                self.contentView.isUserInteractionEnabled = false
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.infoView.alpha = 0
                self.contentView.alpha = 1
                self.contentView.isUserInteractionEnabled = true
            }
        }
    }
    
    private func setUpInfoButtonDesign() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = infoButton.bounds
        gradientLayer.colors = [UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1).cgColor,
                                UIColor(red: 249/255, green: 80/255, blue: 27/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.cornerRadius = 10
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        infoButton.layer.addSublayer(gradientLayer)
        infoButton.layer.shadowOpacity = 0.5
        infoButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        if #available(iOS 15.0, *) {
            infoButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        } else {
            infoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        }
    }
}
