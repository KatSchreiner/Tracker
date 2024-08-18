import UIKit

class StatisticTableViewCell: UITableViewCell {
    let customTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let customDetailTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var gradientBorder: CAGradientLayer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        
        addGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(customTextLabel)
        contentView.addSubview(customDetailTextLabel)
        
        NSLayoutConstraint.activate([
            customTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            customTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            customDetailTextLabel.topAnchor.constraint(equalTo: customTextLabel.bottomAnchor, constant: 7),
            customDetailTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customDetailTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func addGradientBorder() {
        gradientBorder?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradient.locations = [0, 0.5, 1]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 16).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.black.cgColor
        gradient.mask = shape
        
        contentView.layer.insertSublayer(gradient, at: 0)
        
        gradientBorder = gradient
    }
}
