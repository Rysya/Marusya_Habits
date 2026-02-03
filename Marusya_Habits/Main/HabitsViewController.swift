import UIKit

class HabitsViewController: UIViewController {
    
    let bgWindowColor = UIColor.lightGrayHabits.cgColor
    private var header: HabitsHeaderView?
    private var textProgressBar = "Все получится!"
    
    private var habits: [Habit] {
        HabitsStore.shared.habits
    }
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture)
        )
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGrayHabits
        collectionView.layer.borderColor = borderWindowColor
        collectionView.layer.borderWidth = 0.5
        collectionView.register(HabitsCollectionViewCell.self, forCellWithReuseIdentifier: HabitsCollectionViewCell.reuseIdentifier)
        collectionView.register(HabitsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitsHeaderView.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.isUserInteractionEnabled = true
        collectionView.dragInteractionEnabled = true
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews([collectionView])
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        collectionView.reloadData()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .purpleHabits
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        let infoButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = infoButton
        
        let navBarAppearance = UINavigationBarAppearance()
        title = "Сегодня"
        navBarAppearance.backgroundColor = UIColor(
            red: 249/255.0,
            green: 249/255.0,
            blue: 249/255.0,
            alpha: 1.0
        )
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func createButtonTapped() {
        let createVC = UINavigationController(rootViewController: CreateHabitVC())
        createVC.modalPresentationStyle = .fullScreen
        createVC.viewControllers.first?.title = "Создать"
        present(createVC, animated: true)
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: location) else { break }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func  calculateProgress(habits: [Habit]) -> Float {
        let isAllreadyHabits = habits.map({$0.isAlreadyTakenToday}).filter(\.self).count
            let totalHabits = habits.count
            return totalHabits > 0 ? Float(isAllreadyHabits) / Float(totalHabits) : 0
        }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return habits.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitsCollectionViewCell.reuseIdentifier, for: indexPath) as? HabitsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let habit = habits[indexPath.item]
        cell.configure(with: habit, index: indexPath.item)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let habit = habits[indexPath.item]
        let detailsHabit = HabitDetailsViewController()
        detailsHabit.setup(with: habit, index: indexPath.item)
        navigationController?.pushViewController(detailsHabit, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HabitsHeaderView.id,
            for: indexPath
        ) as! HabitsHeaderView
        self.header = header
        
        let progress = calculateProgress(habits: habits)
        if (progress == 1)
        {
        textProgressBar = "Ура! Вы молодец!"
        }
        
        header.configure(
            progress: progress,
            title: textProgressBar
        )
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView,
                       moveItemAt sourceIndexPath: IndexPath,
                       to destinationIndexPath: IndexPath) {
        let movedHabit = HabitsStore.shared.habits.remove(at: sourceIndexPath.item)
        HabitsStore.shared.habits.insert(movedHabit, at: destinationIndexPath.item)
        collectionView.reloadData()
    }
}

extension HabitsViewController: HabitsCollectionViewCellDelegate {
    func didCheckCell(_ index: Int) -> Int {
        let habit = habits[index]
        HabitsStore.shared.track(habit)
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        
        let progress = calculateProgress(habits: habits)
        if let haader = self.header {
            haader.configure(
                progress: progress,
                title: "Все получится!"
            )
        }
        return HabitsStore.shared.habits[index].trackDates.count
    }
}
