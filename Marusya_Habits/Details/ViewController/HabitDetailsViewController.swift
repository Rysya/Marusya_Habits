import UIKit

class HabitDetailsViewController: UIViewController {
    private var habit: Habit?
    private var index = 0
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.layer.borderColor = borderWindowColor
        tableView.layer.borderWidth = 0.5
        tableView.sectionHeaderTopPadding = 0.2
        tableView.register(HabitDetailsTableViewCell.self,
                           forCellReuseIdentifier: HabitDetailsTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews([tableView])
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup(with habit: Habit, index: Int) {
        self.habit = habit
        title = habit.name
        self.index = index
    }
    
    // MARK: - Navigation

    private func setupNavigationBar() {
        let saveBotton = UIButton(type: .system)
        saveBotton.setTitle("Править", for: .normal)
        saveBotton.tintColor = .purpleHabits
        saveBotton.backgroundColor = .clear
        saveBotton.addTarget(self,
                             action: #selector(editButtonTapped),
                             for: .touchUpInside)
        let backBotton = UIButton(type: .system)
        backBotton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backBotton.setTitle("Сегодня", for: .normal)
        backBotton.tintColor = .purpleHabits
        backBotton.backgroundColor = .clear
        backBotton.addTarget(self,
                             action: #selector(habitsVC),
                             for: .touchUpInside)
        let navBarAppearance = UINavigationBarAppearance()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBotton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBotton)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func habitsVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonTapped() {
        let createHabitVC = EditHabitViewController()
        if let habit = habit {
            createHabitVC.state = .edit(habit: habit, index: index)
        }
        navigationController?.pushViewController(createHabitVC, animated: true)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier:
        "habitTableViewCell")
        let formaterDateHabit = HabitsStore.shared.trackDateString(forIndex: HabitsStore.shared.dates.count - 1 - indexPath.row)
        cell.textLabel?.text = formaterDateHabit
        cell.accessoryView = nil
        guard let habit else { return cell }
        if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[HabitsStore.shared.dates.count - 1 - indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        "Активность"
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.text = header.textLabel?.text?.uppercased()
        header.textLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        header.textLabel?.textColor = .systemGray
    }
}
