//
//  FlagCell.swift
//  COUNTRY-FACTS
//
//  Created by Khumar Girdhar on 29/11/21.
//

import UIKit

class FlagCell: UITableViewCell {
    
    var flagImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func getFlagFileName(code: String) -> String {
        return "flag_hd_" + code + ".png"
    }
    
    func configure(for country: countries) {
        self.addSubview(flagImageView)
        
        print("working here")
        flagImageView.image = UIImage(named: getFlagFileName(code: country.alpha2Code))
        flagImageView.layer.cornerRadius = 8
        flagImageView.layer.borderWidth = 0.5
        flagImageView.layer.borderColor = UIColor.gray.cgColor
        flagImageView.layer.masksToBounds = true
        
        let flagHeight: CGFloat                = 120
        let flagRatio: CGFloat                = flagImageView.image?.getImageRatio() ?? 1.5
        let flagWidth                        = flagHeight * flagRatio
        NSLayoutConstraint.activate([
            
            flagImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            flagImageView.heightAnchor.constraint(equalToConstant: flagHeight),
            flagImageView.widthAnchor.constraint(equalToConstant: flagWidth),
            flagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            flagImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }

}
