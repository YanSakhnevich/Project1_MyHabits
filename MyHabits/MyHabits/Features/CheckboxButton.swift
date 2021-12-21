import UIKit

// MARK: - Custom checkbox button
final class CheckboxButton: UIView {

    public var isChecked = false
    
    private let checkMarkImageView: UIImageView = {
        let checkMarkImageView = UIImageView()
        checkMarkImageView.contentMode = .scaleAspectFit
        checkMarkImageView.tintColor = .white
        checkMarkImageView.image = checkMarkImage
        
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        return checkMarkImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemOrange.cgColor
        layer.cornerRadius = 19
        backgroundColor = .white
        
        addSubview(checkMarkImageView)
        
        let checkMarkConstraints = [
            checkMarkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkMarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(checkMarkConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
