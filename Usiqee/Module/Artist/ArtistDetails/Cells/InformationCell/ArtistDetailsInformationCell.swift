//
//  ArtistDetailsInformationCell.swift
//  Usiqee
//
//  Created by Amine on 16/06/2021.
//

import UIKit
import Firebase

class ArtistDetailsInformationCell: UITableViewCell {

    // MARK: - Constants
    enum Constants {
        static let identifier = "ArtistDetailsInformationCell"
        static let nib = UINib(nibName: Constants.identifier, bundle: nil)
        fileprivate static let cornerRadius: CGFloat = 11
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var pseudosLabel: UILabel!
    @IBOutlet weak private var birthNameLabel: UILabel!
    @IBOutlet weak private var birthDateLabel: UILabel!
    @IBOutlet weak private var startActivityYearLabel: UILabel!
    @IBOutlet weak private var provenanceLabel: UILabel!
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideAllLabels()
    }
    
    func configure(artist: Artist) {
        set(pseudos: artist.pseudos)
        set(birthName: artist.birthName)
        set(birthDate: artist.birthDate)
        set(startActivityYear: artist.startActivityYear)
        set(provenance: artist.provenance)
    }
    
    func configure(band: Band) {
        set(pseudos: band.pseudos)
        set(startActivityYear: band.startActivityYear)
        set(provenance: band.provenance)
    }
    
    // MARK: - Private
    private func setupUI() {
        containerView.layer.cornerRadius = Constants.cornerRadius
        hideAllLabels()
        setupLabels()
    }
    
    private func setupLabels() {
        titleLabel.text = L10N.ArtistDetails.Bio.Information.title
        titleLabel.font = Fonts.ArtistDetails.Bio.title
        pseudosLabel.font = Fonts.ArtistDetails.Bio.description
        birthNameLabel.font = Fonts.ArtistDetails.Bio.description
        birthDateLabel.font = Fonts.ArtistDetails.Bio.description
        startActivityYearLabel.font = Fonts.ArtistDetails.Bio.description
        provenanceLabel.font = Fonts.ArtistDetails.Bio.description
    }
    
    private func hideAllLabels() {
        pseudosLabel.isHidden = true
        birthNameLabel.isHidden = true
        birthDateLabel.isHidden = true
        startActivityYearLabel.isHidden = true
        provenanceLabel.isHidden = true
    }
    
    private func set(pseudos: String?) {
        if let pseudos = pseudos {
            pseudosLabel.text = L10N.ArtistDetails.Bio.Information.pseudos(pseudos)
            pseudosLabel.isHidden = false
        }
    }
    
    private func set(birthName: String?) {
        if let birthName = birthName {
            birthNameLabel.text = L10N.ArtistDetails.Bio.Information.birthName(birthName)
            birthNameLabel.isHidden = false
        }
    }
    
    private func set(birthDate: Timestamp?) {
        if let birthDate = birthDate {
            birthDateLabel.text = L10N.ArtistDetails.Bio.Information.birthDate(birthDate.long)
            birthDateLabel.isHidden = false
        }
    }
    
    private func set(startActivityYear: String?) {
        if let startActivityYear = startActivityYear {
            startActivityYearLabel.text = L10N.ArtistDetails.Bio.Information.activity(startActivityYear)
            startActivityYearLabel.isHidden = false
        }
    }
    
    private func set(provenance: String?) {
        if let provenance = provenance {
            provenanceLabel.text = L10N.ArtistDetails.Bio.Information.provenance(provenance)
            provenanceLabel.isHidden = false
        }
    }
}
