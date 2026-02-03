import UIKit

class HabitsHeaderView: UICollectionReusableView {
    
    static let id = "HabitsHeaderView"
    
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = .purpleHabits
        view.trackTintColor = .systemGray5
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.progress = 0.0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Все получится!"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private let headerElementsSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    func configure(progress: Float, title: String, animated: Bool = true) {
        progressView.setProgress(progress, animated: animated)
        titleLabel.text = title
        progressLabel.text = "\(Int(progress * 100))%"
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        headerElementsSpacer.addSubviews([titleLabel, progressView, progressLabel])
        addSubviews([headerElementsSpacer])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerElementsSpacer.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerElementsSpacer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerElementsSpacer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            headerElementsSpacer.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: headerElementsSpacer.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: headerElementsSpacer.leadingAnchor, constant: 16),
            
            progressLabel.trailingAnchor.constraint(equalTo: headerElementsSpacer.trailingAnchor, constant: -16),
            progressLabel.topAnchor.constraint(equalTo: headerElementsSpacer.topAnchor, constant: 10),
            
            progressView.leadingAnchor.constraint(equalTo: headerElementsSpacer.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: headerElementsSpacer.trailingAnchor, constant: -16),
            progressView.bottomAnchor.constraint(equalTo: headerElementsSpacer.bottomAnchor, constant: -15),
            progressView.heightAnchor.constraint(equalToConstant: 7),
        ])
    }
}
