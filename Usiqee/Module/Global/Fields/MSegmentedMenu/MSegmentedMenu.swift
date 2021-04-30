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
    @IBOutlet weak private var newsIsSelectedView: UIView!
    @IBOutlet weak private var calendarIsSelectedView: UIView!
    @IBOutlet weak private var discographyIsSelectedView: UIView!
    @IBOutlet weak private var newsLabel: UILabel!
    @IBOutlet weak private var calendarLabel: UILabel!
    @IBOutlet weak private var discographyLabel: UILabel!
    
    // MARK: - Properties
    private var currentSelectedItem: Int = 1
    weak var delegate: MSegmentedMenuDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
        handleMenuUpdated()
    }

    private func setupView() {
        newsLabel.text = L10N.ArtistDetails.Menu.news
        newsLabel.font = Fonts.ArtistDetails.Menu.news
        calendarLabel.text = L10N.ArtistDetails.Menu.calendar
        calendarLabel.font = Fonts.ArtistDetails.Menu.calendar
        discographyLabel.text = L10N.ArtistDetails.Menu.discography
        discographyLabel.font = Fonts.ArtistDetails.Menu.discography
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("MSegmentedMenu", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func reset() {
        newsIsSelectedView.isHidden = true
        calendarIsSelectedView.isHidden = true
        discographyIsSelectedView.isHidden = true
        newsLabel.textColor = Colors.gray
        calendarLabel.textColor = Colors.gray
        discographyLabel.textColor = Colors.gray
    }
    
    private func handleMenuUpdated() {
        reset()
        
        switch currentSelectedItem {
        case 1:
            newsIsSelectedView.isHidden = false
            newsLabel.textColor = .white
        case 2:
            calendarIsSelectedView.isHidden = false
            calendarLabel.textColor = .white
        case 3:
            discographyIsSelectedView.isHidden = false
            discographyLabel.textColor = .white
        default:
            break
        }
    }
}

// MARK: - IBACtions
extension MSegmentedMenu {
    @IBAction func onButtonTapped(_ sender: UIButton) {
        guard sender.tag != currentSelectedItem else { return }
        
        currentSelectedItem = sender.tag
        delegate?.didSelectItem(at: currentSelectedItem)
        
        handleMenuUpdated()
    }
}
