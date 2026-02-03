import UIKit

protocol HabitsCollectionViewCellDelegate: AnyObject {
    func didCheckCell(_ index: Int) -> Int
}

class HabitsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HabitsCollectionViewCell"
    private let defaultColorHabit = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    private var indexHabit: Int = 0
    weak var delegate: HabitsCollectionViewCellDelegate?
    private var isChecked: Bool = false
    
    private let nameHabit: UILabel = {
        var name = UILabel(frame: .zero)
        name.text = "text"
        name.textColor = .black
        name.numberOfLines = 2
        return name
    }()
    
    private let labelTime: UILabel = {
        var name = UILabel(frame: .zero)
        name.text = "text"
        name.textColor = .systemGray2
        name.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        name.numberOfLines = 2
        return name
    }()
    
    private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var labelCount: UILabel = {
        var name = UILabel(frame: .zero)
        name.textColor = .systemGray2
        name.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        name.numberOfLines = 1
        return name
    }()
    
    private lazy var buttonCircle: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = defaultColorHabit
        button.backgroundColor = defaultColorHabit
        button.layer.borderColor = defaultColorHabit.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        titleStackView.addArrangedSubview(nameHabit)
        titleStackView.addArrangedSubview(labelTime)
        contentView.addSubviews([titleStackView, labelCount, buttonCircle])
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isChecked = false
    }
    
    func configure(with habit: Habit, index: Int) {
        nameHabit.text = habit.name
        buttonCircle.layer.borderColor = habit.color.cgColor
        if habit.isAlreadyTakenToday {
            buttonCircle.backgroundColor = habit.color
            isChecked = true
        } else {
            buttonCircle.backgroundColor = defaultColorHabit
        }
        indexHabit = index
        labelCount.text = "Счетчик: \(habit.trackDates.count)"
    }
 
    @objc private func trackButtonTapped() {
        if !isChecked, let countCheckTrack = delegate?.didCheckCell(indexHabit) {
            labelCount.text = "Счетчик: \(countCheckTrack)"
        }
    }
  
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            labelCount.widthAnchor.constraint(equalToConstant: 188),
            labelCount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            labelCount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            buttonCircle.widthAnchor.constraint(equalToConstant: 36),
            buttonCircle.heightAnchor.constraint(equalToConstant: 36),
            buttonCircle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
