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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var newsIsSelectedView: UIView!
    @IBOutlet weak var calendarIsSelectedView: UIView!
    @IBOutlet weak var discographyIsSelectedView: UIView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var discographyLabel: UILabel!
    
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
    
    // MARK: - IBACtions
    
    @IBAction func onButtonTapped(_ sender: UIButton) {
        guard sender.tag != currentSelectedItem else { return }
        
        currentSelectedItem = sender.tag
        delegate?.didSelectItem(at: currentSelectedItem)
        
        newsIsSelectedView.isHidden = true
        calendarIsSelectedView.isHidden = true
        discographyIsSelectedView.isHidden = true
        
        switch sender.tag {
        case 1:
            newsIsSelectedView.isHidden = false
        case 2:
            calendarIsSelectedView.isHidden = false
        case 3:
            discographyIsSelectedView.isHidden = false
        default:
            break
        }
    }
    
    // MARK: - Private
    private func commonInit() {
        loadView()
        setupView()
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
}
