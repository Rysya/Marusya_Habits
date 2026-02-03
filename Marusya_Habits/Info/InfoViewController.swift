import UIKit

class InfoViewController: UIViewController {
    
    private var titleInfo: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Привычка за 21 день"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private let textInfoView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = .darkGray
        textView.textAlignment = .natural
       
        let text = """
            Прохождение этапов, за которые за 21 день вырабатывается привычка, подчиняется следующему алгоритму:
            
            1. Провести 1 день без обращения к старым привычкам, стараться вести себя так, как будто цель, загаданная в перспективу, находится на расстоянии шага.
            
            2. Выдержать 2 дня в прежнем состоянии самоконтроля.
            
            3. Отметить в дневнике первую неделю изменений и подвести первые итоги — что оказалось тяжело, что — легче, с чем еще предстоит серьезно бороться.
            
            4. Поздравить себя с прохождением первого серьезного порога в 21 день. За это время отказ от дурных наклонностей уже примет форму осознанного преодоления и человек сможет больше работать в сторону принятия положительных качеств.
            
            5. Держать планку 40 дней. Практикующий методику уже чувствует себя освободившимся от прошлого негатива и двигается в нужном направлении с хорошей динамикой.
            
            6. На 90-й день соблюдения техники все лишнее из «прошлой жизни» перестает напоминать о себе, и человек, оглянувшись назад, осознает себя полностью обновившимся.
            """
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2 // межстрочный интервал
        paragraphStyle.paragraphSpacing = 0 // интервал между абзацами
        paragraphStyle.firstLineHeadIndent = 0 // отступ первой строки
        paragraphStyle.headIndent = 0 // отступ для всех строк, кроме первой
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        textView.attributedText = attributedString
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
       return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Информация"
        view.addSubviews([titleInfo, textInfoView])
        setupConstraints()
    }
    
    private func setupConstraints() {
        let abzac = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleInfo.topAnchor.constraint(equalTo: abzac.topAnchor, constant: 20),
            titleInfo.leadingAnchor.constraint(equalTo: abzac.leadingAnchor, constant: 20),
            
            textInfoView.topAnchor.constraint(equalTo: titleInfo.bottomAnchor, constant: 20),
            textInfoView.leadingAnchor.constraint(equalTo: abzac.leadingAnchor, constant: 16),
            textInfoView.trailingAnchor.constraint(equalTo: abzac.trailingAnchor, constant: -20),
            textInfoView.bottomAnchor.constraint(equalTo: abzac.bottomAnchor, constant: -20),
        ])
    }
}
