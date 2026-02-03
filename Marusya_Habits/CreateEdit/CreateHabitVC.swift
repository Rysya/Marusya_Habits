import UIKit

class CreateHabitVC: UIViewController {
    
    enum State {
        case edit(habit: Habit, index: Int)
        case create
    }
    
    var state: State = .create
    private var isKeyboardVisible = false
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Название".uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private var titleField: UITextField = {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        let textFieldStatus = UITextField()
        textFieldStatus.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textFieldStatus.leftView = leftPaddingView
        textFieldStatus.leftViewMode = .always
        textFieldStatus.textColor = .blueHabits
        textFieldStatus.backgroundColor = .clear
        textFieldStatus.placeholder = "Бегать по утрам, спать по 8 часов и т.п."
        textFieldStatus.isHidden = false
        textFieldStatus.isUserInteractionEnabled = true
        return textFieldStatus
    }()
    
    private let colorLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "цвет".uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        colorWell.layer.cornerRadius = 15
        colorWell.addTarget(self, action: #selector(colorWellAction), for: .valueChanged)
        return colorWell
    }()
    
    private let dateLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "время".uppercased()
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private let datePickerLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Каждый день в"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private var datePickerText: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "08:00"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .purpleHabits
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.date = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = .current
        datePicker.backgroundColor = .clear
        datePicker.tintColor = .blueHabits
        datePicker.addTarget(self, action: #selector(datePickerAction), for: .valueChanged)
        return datePicker
    }()
    
    private var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private var titleMyHabits: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "MyHabits: create habits page"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.purpleHabits
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.isHidden = true
        button.addTarget(self, action: #selector(showAlertButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        dateStackView.addArrangedSubview(datePickerLabel)
        dateStackView.addArrangedSubview(datePickerText)
        scrollView.addSubviews([titleLabel, titleField, colorLabel, colorWell, dateLabel, dateStackView, datePicker])
        view.addSubviews([scrollView, deleteButton])
        setupHideKeyboardOnTap()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        subscribeKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        if case let .edit(habit, _) = state {
            titleField.text = habit.name
            colorWell.selectedColor = habit.color
            datePicker.date = habit.date
            datePickerAction()
            deleteButton.isHidden = false
            title = "Править"
        }
    }
    
    @objc private func colorWellAction(_ sender: UIColorWell) {
        guard let color = sender.backgroundColor else { return }
        colorWell.backgroundColor = color
    }
    
    @objc private func datePickerAction() {
        datePickerText.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .none, timeStyle: .short)
    }
    
    @objc private func showAlertButtonTapped() {
        showDeleteAlert()
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "Удалить привычку",
                                      message: "Вы уверены, что хотите удалить привычку?",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить",
                                         style: .destructive) { [weak self] _ in
            guard let self else { return }
            if case let .edit(_, index) = self.state {
                HabitsStore.shared.habits.remove(at: index)
            }
            navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
    
        let saveBotton = UIButton(type: .system)
        saveBotton.setTitle("Сохранить", for: .normal)
        saveBotton.tintColor = .purpleHabits
        saveBotton.backgroundColor = .clear
        saveBotton.addTarget(self,
                             action: #selector(saveButtonTapped),
                             for: .touchUpInside)
        let backBotton = UIButton(type: .system)
        backBotton.setTitle("Отменить", for: .normal)
        backBotton.tintColor = .purpleHabits
        backBotton.backgroundColor = .clear
        backBotton.addTarget(self,
                             action: #selector(habitsVC),
                             for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBotton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBotton)
    }
    
    @objc private func habitsVC() {
        switch state {
            case .edit:
                navigationController?.popViewController(animated: true)
            case .create:
                dismiss(animated: true)
        }
    }
    
    @objc private func saveButtonTapped() {
        if case let .edit(_, index) = self.state {
            HabitsStore.shared.habits[index].name = titleField.text ?? ""
            HabitsStore.shared.habits[index].date = datePicker.date
            HabitsStore.shared.habits[index].color = colorWell.selectedColor ?? .black
            HabitsStore.shared.save()
            navigationController?.popToRootViewController(animated: true)
        } else if case .create = self.state {
            let habit = Habit(name: titleField.text ?? "", date: datePicker.date, color: colorWell.selectedColor ?? .lightGrayHabits)
            HabitsStore.shared.habits.append(habit)
            dismiss(animated: true)
        }
    }
    // MARK: - Navigation
    
    func subscribeKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard isKeyboardVisible == false,
        let ks = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        isKeyboardVisible = true
        let contentInsets = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: ks.height - view.safeAreaInsets.bottom + 20,
                                         right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        isKeyboardVisible = false
    }
    
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let titleField = titleField.convert(titleField.bounds, to: view)
        if !titleField.contains(location) {
            view.endEditing(true)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 21),
            
            titleField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            titleField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 46),
            
            colorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 83),
            
            colorWell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorWell.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 108),
            
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 153),
            
            dateStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 178),
            
            datePicker.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 16),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
