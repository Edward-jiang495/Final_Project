//
//  CustomTableViewCell.swift
//  Final_project
//
//  Created by Zhengran Jiang on 12/5/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    lazy var backView: UIView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 50));
        return view;
    }()
    
    lazy var label: UILabel = {
        let screenSize: CGRect = UIScreen.main.bounds

        let label = UILabel(frame: CGRect(x: 60, y: 10, width: screenSize.width-80, height: 30))
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(label)

        // Configure the view for the selected state
    }

}
