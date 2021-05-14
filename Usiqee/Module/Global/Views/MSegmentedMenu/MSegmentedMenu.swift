//
//  MSegmentedMenu.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import UIKit

protocol MSegmentedMenuDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

class MSegmentedMenu: UIView {

    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var stackview: UIStackView!
    
    // MARK: - Properties
    private var currentSelectedItem: Int = 0
    private var contentTexts: [String] = []
    private var tabs: [MSegmentedMenuItem] = []
    weak var delegate: MSegmentedMenuDelegate?
    var selectedItem: Int {
        currentSelectedItem
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configure(with tabs:String...) {
        self.tabs.removeAll()
        contentTexts.removeAll()
        stackview.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, value) in tabs.enumerated() {
            contentTexts.append(value)
            
            let item = MSegmentedMenuItem()
            item.tag = index
            item.delegate = self
            item.dataSource = self
            self.tabs.append(item)
            stackview.addArrangedSubview(item)
        }
        
        handleMenuUpdated()
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("MSegmentedMenu", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func handleMenuUpdated() {
        tabs.forEach {
            $0.reload()
        }
    }
}

// MARK: - MSegmentedMenuItemDelegate
extension MSegmentedMenu: MSegmentedMenuItemDelegate {
    func didSelectedItem(at index: Int) {
        guard index != currentSelectedItem else { return }
        
        currentSelectedItem = index
        delegate?.didSelectItem(at: currentSelectedItem)
        
        handleMenuUpdated()
    }
}

// MARK: - MSegmentedMenuItemDataSource
extension MSegmentedMenu: MSegmentedMenuItemDataSource {
    func text(for index: Int) -> String {
        contentTexts[index]
    }
    
    func isSelectedItem(at index: Int) -> Bool {
        index == currentSelectedItem
    }
}
