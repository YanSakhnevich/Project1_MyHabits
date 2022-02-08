import UIKit

class HabitDetailsViewController: UIViewController {
    
    
    var callerFromDetailToHabits: UpdatingCollectionDataDelegate?
    
    let habit: Habit
    
    // MARK: Initializations
    init(habit: Habit) {
        
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var habitViewController = HabitViewController(habit: habit)
    
    
    // MARK: - Content
    // Table view for habit's detail
    private lazy var habitDetailTableView: UITableView = {
        let habitDetailTableView = UITableView(frame: .zero, style: .grouped)
        
        habitDetailTableView.register(HabitDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: HabitDetailsHeaderView.self))
        habitDetailTableView.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: String(describing: HabitDetailsTableViewCell.self))
        
        habitDetailTableView.delegate = self
        habitDetailTableView.dataSource = self
        
        habitDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        return habitDetailTableView
    }()
    
    
    // MARK: - Functions
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitViewController.delegatorForCalls = self
        
        view.backgroundColor = .systemGray6
        habitDetailTableView.backgroundColor = .systemGray6
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: editHabitViewControllerTitle, style: .plain, target: self, action: #selector(editThisHabit))
        navigationController?.navigationBar.tintColor = customPurpleColor ?? .systemPurple
        navigationItem.rightBarButtonItem?.tintColor = customPurpleColor ?? .systemPurple
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(habitDetailTableView)
        
        let constraints = [
            habitDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitDetailTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitDetailTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    // Little crutch for close current view when habit was deleted
    private func checkingForDeleting() {
        
        if habitViewController.checkerForDeletingHabitWithStyle {
            navigationController?.popViewController(animated: true)
            print("it worked")
        }
    }
    
    // MARK: - Actions
    // Open editing view for this habit
    @objc func editThisHabit() {
        
        let habitViewController = HabitViewController(habit: habit)
        habitViewController.deleteHabitButton.isHidden = false

        
        habitViewController.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(habitViewController, animated: true)
    }
}

// MARK: - Extensions
// UITableViewDelegate
extension HabitDetailsViewController: UITableViewDelegate {
    
    // Height for header in section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
}

// UITableViewDataSource
extension HabitDetailsViewController: UITableViewDataSource {
    
    // Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return habit.trackDates.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HabitDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: HabitDetailsTableViewCell.self)) as! HabitDetailsTableViewCell
        
        cell.textLabel?.text = HabitsStore.shared.trackDateString(forIndex: HabitsStore.shared.dates.count - 1 - indexPath.item)
        
        if HabitsStore.shared.habit(habit, isTrackedIn: HabitsStore.shared.dates[HabitsStore.shared.dates.count - 1 - indexPath.item]) == true {
            cell.checkMarkImage.isHidden = false
        }
        
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    // View for header in section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return HabitDetailsHeaderView()
    }
}

// MakeACallFromEditToDetail
extension HabitDetailsViewController: MakeACallFromEditToDetail {
    
    // Making a call
    func makeACall() {
        
        checkingForDeleting()
        self.callerFromDetailToHabits?.updateCollection()
    }
}

extension HabitDetailsViewController: UpdatingCollectionDataDelegate {
    
    // Updating data
    func updateCollection() {
        
        habitDetailTableView.reloadData()
    }
}
