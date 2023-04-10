//
//  infoView.swift
//  WeatherBrick
//
//  Created by Vladyslav Petrenko on 10/04/2023.
//  Copyright © 2023 VAndrJ. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var hideButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setUpButton()
        setUpContentView()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("infoView", owner: self)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
    
    private func setUpButton() {
        hideButton.layer.borderColor = hideButton.titleColor(for: .normal)!.cgColor
        hideButton.layer.borderWidth = 1
        hideButton.layer.cornerRadius = 15
    }
    
    private func setUpContentView() {
        layer.cornerRadius = 15
        layer.backgroundColor = UIColor(red: 251/255, green: 95/255, blue: 41/255, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: -1, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = CGPath(rect: CGRect(x: 0, y: 5, width: bounds.width - 20, height: bounds.height - 10), transform: nil)
        layer.shadowRadius = 10
        contentView.layer.backgroundColor = UIColor(red: 255/255, green: 153/255, blue: 96/255, alpha: 1).cgColor
        contentView.layer.cornerRadius = 15
    }
}
