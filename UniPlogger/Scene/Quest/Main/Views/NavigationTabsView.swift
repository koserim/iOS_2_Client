//
//  NavigationTabsView.swift
//  UniPlogger
//
//  Created by woong on 2020/10/01.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import SnapKit

class NavigationTabsView<T>: UIStackView {
    
    private var items = [T]()
    private(set) var activeTextColor: UIColor?
    private(set) var defaultTextColor: UIColor?
    private(set) var buttonTintColor: UIColor?
    
    var tapHandler: ((T) -> Void)?
    var selectedIndex: Int? {
        didSet {
            guard let index = selectedIndex else { return }
            tapHandler?(items[index])
            updateButtons()
        }
    }
    
    
    init(items: [T], tintColor: UIColor?) {
        self.items = items
        self.buttonTintColor = tintColor
        super.init(frame: .zero)
        for (idx, item) in items.enumerated() {
            let button = UIButton()
            button.setTitle(String(describing: item), for: .normal)
            addArrangedSubview(button)
            button.tag = idx
            button.layer.cornerRadius = 21
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
    }
    
    func configure(activeTextColor: UIColor?, defaultTextColor: UIColor?) {
        self.activeTextColor = activeTextColor
        self.defaultTextColor =  defaultTextColor
    }
    
    private func updateButtons() {
        subviews.compactMap { $0 as? UIButton }.enumerated().forEach { (idx, button) in
            if idx == selectedIndex {
                button.setTitleColor(activeTextColor, for: .normal)
                button.titleLabel?.font = .roboto(ofSize: 16, weight: .bold)
                button.backgroundColor = buttonTintColor
            } else {
                button.setTitleColor(defaultTextColor, for: .normal)
                button.titleLabel?.font = .roboto(ofSize: 16, weight: .regular)
                button.backgroundColor = .clear
            }
        }
    }
    
    @objc private func didTapButton(_ button: UIButton) {
        selectedIndex = button.tag
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
