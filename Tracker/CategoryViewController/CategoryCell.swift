import UIKit

final class CategoryCell: UITableViewCell {
    static let identifier = "CategoryCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        backgroundColor = .yBackground
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configCell(isSingleCell: Bool, isFirstCell: Bool, isLastCell: Bool) {
        layer.cornerRadius = 0
        layer.maskedCorners = []
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        if isSingleCell {
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width)
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirstCell {
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastCell {
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.width)
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}
