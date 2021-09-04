//
//  MSegmentedMenuItem.swift
//  Usiqee
//
//  Created by Amine on 03/05/2021.
//

import UIKit

protocol MSegmentedMenuItemDelegate: class {
    func didSelectedItem(at index: Int)
}

protocol MSegmentedMenuItemDataSource: class {
    func text(for index: Int) -> String
    func isSelectedItem(at index: Int) -> Bool
}

class MSegmentedMenuItem: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var isSelectedView: UIView!
    @IBOutlet weak private var contentLabel: UILabel!
    
    weak var delegate: MSegmentedMenuItemDelegate?
    weak var dataSource: MSegmentedMenuItemDataSource?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func reload() {
        let isSelected = dataSource?.isSelectedItem(at: tag) ?? false
        contentLabel.text = dataSource?.text(for: tag)
        
        if isSelected {
            contentLabel.textColor = .white
            isSelectedView.isHidden = false
        } else {
            contentLabel.textColor = Colors.gray
            isSelectedView.isHidden = true
        }
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
    }

    private func setupView() {
        contentLabel.font = Fonts.ArtistDetails.Menu.item
        contentLabel.textColor = .white
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("MSegmentedMenuItem", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

// MARK: - IBACtions
extension MSegmentedMenuItem {
    @IBAction func onButtonTapped(_ sender: UIButton) {
        delegate?.didSelectedItem(at: tag)
    }
}
