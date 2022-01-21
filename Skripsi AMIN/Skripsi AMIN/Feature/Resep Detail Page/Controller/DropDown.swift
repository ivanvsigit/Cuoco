//
//  DropDown.swift
//  TableTest
//
//  Created by Ivan Valentino Sigit on 13/01/22.
//

import UIKit

class DropDown: UITableViewCell {
    var data: DropData?{
        didSet{
            guard let data = data else {
                return
            }
            self.title.text = data.title
//            self.desc.text = data.desc
        }
    }
    
    func animate(){
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    fileprivate let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "Course Title"
        label.textColor = .white
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let desc: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Bahan-bahan"
        label.textColor = .white
        label.numberOfLines = -1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.backgroundColor = UIColor(named: "PrimaryColor")
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 3, height: 3)
        v.layer.cornerRadius = 10
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(container)
        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        
        container.addSubview(title)
        container.addSubview(desc)
        
        title.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
        title.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        desc.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        desc.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
        desc.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
        desc.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
