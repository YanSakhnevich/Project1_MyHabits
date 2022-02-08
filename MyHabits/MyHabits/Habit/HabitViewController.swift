import UIKit

class HabitViewController: UIViewController {
    
    weak var dataDelegator: UpdatingCollectionDataDelegate?
    weak var delegatorForHabit: UpdatingCollectionDataDelegate?
    var delegatorForCalls: MakeACallFromEditToDetail?
    public var checkerForDeletingHabitWithStyle = false


    private var habitColor: UIColor = .systemOrange
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatText
        dateFormatter.locale = Locale(identifier: dateFormatID)
        
        return dateFormatter
    }()
    
    var habit: Habit?
    
    init (habit: Habit?) {
        super.init(nibName: nil, bundle: nil)
        self.habit = habit
        
        setupNavBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Content
    // Name Label
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = labelNameHabits
        nameLabel.font = .boldSystemFont(ofSize: 13)
        
        return nameLabel
    }()
    
    // Name of new habit Text Field
    private let newHabitNameTextField: UITextField = {
        let newHabitNameTextField = UITextField()
        newHabitNameTextField.font = .systemFont(ofSize: 17)
        newHabitNameTextField.textColor = customBlueColor ?? .systemBlue
        newHabitNameTextField.placeholder = newHabitPlaceHolderText
        newHabitNameTextField.returnKeyType = .done
        
        return newHabitNameTextField
    }()
    
    // Color Label
    private let colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = colorLabelText
        colorLabel.font = .boldSystemFont(ofSize: 13)
        
        return colorLabel
    }()
    
    // Color Picker for new habit
    private let newHabitColorPickerButton: UIButton = {
        let newHabitColorPickerButton = UIButton(frame:
                                                    CGRect(
                                                        x: 0,
                                                        y: 0,
                                                        width: 1,
                                                        height: 1
                                                    )
        )
        newHabitColorPickerButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        newHabitColorPickerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        newHabitColorPickerButton.backgroundColor = customOrangeColor ?? .systemOrange
        
        newHabitColorPickerButton.layer.cornerRadius = 15
        
        newHabitColorPickerButton.isUserInteractionEnabled = true
        newHabitColorPickerButton.addTarget(self, action: #selector(didTappedOnColorPicker), for: .touchUpInside)
        
        return newHabitColorPickerButton
    }()
    
    let deleteHabitButton: UIButton = {
        let deleteHabitButton = UIButton(type: .system)
        deleteHabitButton.setTitle(deleteHabitTitle, for: .normal)
        deleteHabitButton.setTitleColor(.red, for: .normal)
        deleteHabitButton.addTarget(self, action: #selector(showDeleteAlert(_:)), for: .touchUpInside)
        deleteHabitButton.isHidden = true

        return deleteHabitButton
    }()
    
    // Time Label
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = timeLabelTitle
        timeLabel.font = .boldSystemFont(ofSize: 13)
        
        return timeLabel
    }()
    
    // New habit time text (text part)
    private let newHabitTimeTextLabel: UILabel = {
        let newHabitTimeTextLabel = UILabel()
        newHabitTimeTextLabel.text = newHabitTimeText
        
        return newHabitTimeTextLabel
    }()
    
    // New habit time text (time part)
    private let newHabitTimeDateLabel: UILabel = {
        let newHabitTimeDateLabel = UILabel()
        newHabitTimeDateLabel.textColor = customPurpleColor
        
        return newHabitTimeDateLabel
    }()
    
    
    // New habit Time Picker
    private let newHabitTimeDatePicker: UIDatePicker = {
        let newHabitTimeDatePicker = UIDatePicker()
        newHabitTimeDatePicker.datePickerMode = .time
        newHabitTimeDatePicker.preferredDatePickerStyle = .wheels
        newHabitTimeDatePicker.locale = Locale(identifier: dateFormatID)
        
        newHabitTimeDatePicker.addTarget(self, action: #selector(dateHasBeenChenged), for: .valueChanged)
        
        return newHabitTimeDatePicker
    }()
    
    // MARK:  - Functions
    // View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        habitColor = newHabitColorPickerButton.backgroundColor!
        
        newHabitTimeDateLabel.text = dateFormatter.string(from: newHabitTimeDatePicker.date)
        
        newHabitNameTextField.delegate = self
        
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    // Tap

    @objc func tap() {
        newHabitNameTextField.resignFirstResponder()
    }
    
    // Setup views
    private func setupViews() {
        
        view.addSubviews(
            nameLabel,
            newHabitNameTextField,
            colorLabel,
            newHabitColorPickerButton,
            timeLabel,
            newHabitTimeTextLabel,
            newHabitTimeDateLabel,
            newHabitTimeDatePicker,
            deleteHabitButton
        )
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: contentVerticalSpacer),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacer),
            
            newHabitNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: smallVerticalSpacer),
            newHabitNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacer),
            newHabitNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -1 * horizontalSpacer),
            
            colorLabel.topAnchor.constraint(equalTo: newHabitNameTextField.bottomAnchor, constant: bigVerticalSpacer),
            colorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacer),
            
            newHabitColorPickerButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: smallVerticalSpacer),
            newHabitColorPickerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacer),
            
            timeLabel.topAnchor.constraint(equalTo: newHabitColorPickerButton.bottomAnchor, constant: bigVerticalSpacer),
            timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacer),
            
            newHabitTimeTextLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: smallVerticalSpacer),
            newHabitTimeTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacer),
            
            newHabitTimeDateLabel.topAnchor.constraint(equalTo: newHabitTimeTextLabel.topAnchor),
            newHabitTimeDateLabel.leadingAnchor.constraint(equalTo: newHabitTimeTextLabel.trailingAnchor),
            
            newHabitTimeDatePicker.topAnchor.constraint(equalTo: newHabitTimeTextLabel.bottomAnchor, constant: bigVerticalSpacer),
            newHabitTimeDatePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newHabitTimeDatePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newHabitTimeDatePicker.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            deleteHabitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // Setup navigation bar
    private func setupNavBar() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .init(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: saveButtonTitle, style: .plain, target: self, action: #selector(saveTabBarButtonPressed))
        navigationItem.rightBarButtonItem?.style = .done
        
        navigationItem.rightBarButtonItem?.tintColor = customPurpleColor ?? .systemPurple
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: canelButtonTitle, style: .plain, target: self, action: #selector(cancelTabBarButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = customPurpleColor ?? .systemPurple
        
        view.backgroundColor = .white
        title = habitViewControllerTitle
        
    }
    

    // MARK: - Actions
    // Saving new habit
    @objc func saveTabBarButtonPressed(_ sender: UIBarButtonItem) {
    
        let newHabit = Habit(
            name: newHabitNameTextField.text ?? noDataText,
            date: newHabitTimeDatePicker.date,
            color: habitColor
        )
        let store = HabitsStore.shared
        
        if ((newHabitNameTextField.text?.isEmpty) != Optional(false)) {
            newHabitNameTextField.text = newHabitName
        }
        if let habit = habit {
            let editedHabit = Habit(
                name: newHabitNameTextField.text ?? noDataText,
                date: newHabitTimeDatePicker.date,
                color: newHabitColorPickerButton.backgroundColor ?? habit.color
            )
            editedHabit.trackDates = habit.trackDates
            
            reloadInputViews()
            
            if let index = HabitsStore.shared.habits.firstIndex(where: { $0 == self.habit }) {
                HabitsStore.shared.habits[index] = editedHabit
            }
            
            navigationController?.popToRootViewController(animated: true)
            
            self.delegatorForCalls?.makeACall()
        } else {
            store.habits.append(newHabit)
            navigationController?.popViewController(animated: true)
            self.dataDelegator?.updateCollection()
            reloadInputViews()
        }
        
    }
    
    @objc func showDeleteAlert(_ sender: Any) {

        guard let habit = habit else { return }
        let deleteAlertController = UIAlertController(title: deleteHabitTitle, message: "Вы хотите удалить привычку '\(habit.name)'?", preferredStyle: .alert)

        let cancelDeleteAction = UIAlertAction(title: cancelDeleteActionTitle, style: .default) { _ in
        }

        let completeDeleteAction = UIAlertAction(title: completeDeleteActionTitle, style: .destructive) { _ in
            if let oldHabit = HabitsStore.shared.habits.firstIndex(where: ({ $0.name == habit.name })) {
                HabitsStore.shared.habits.remove(at: oldHabit )
            }
            self.navigationController?.popToRootViewController(animated: true)
            self.delegatorForHabit?.updateCollection()

            self.checkerForDeletingHabitWithStyle.toggle()

        }

        deleteAlertController.addAction(cancelDeleteAction)
        deleteAlertController.addAction(completeDeleteAction)

        self.present(deleteAlertController, animated: true, completion: nil)
    }
    
    // Cancel creating new habit
    @objc func cancelTabBarButtonPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        self.dataDelegator?.updateCollection()
    }
    
    // Opening color picker
    @objc private func didTappedOnColorPicker() {
        
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.delegate = self
        colorPickerViewController.supportsAlpha = false
        present(colorPickerViewController, animated: true)
    }
    
    // Date has been changed via DatePicker
    @objc private func dateHasBeenChenged(_ sender: UIDatePicker) {
        
        newHabitTimeDateLabel.text = dateFormatter.string(from: sender.date)
        
    }
}

// MARK: - Extensions
// UIColorPickerViewControllerDelegate
extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    // Color picker view controller did finish
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        habitColor = selectedColor
        newHabitColorPickerButton.backgroundColor = selectedColor
        newHabitTimeDateLabel.textColor = selectedColor
    }
    
    // Color picker view controller did select color
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        habitColor = selectedColor
        newHabitColorPickerButton.backgroundColor = selectedColor
    }
}

// UITextFieldDelegate
extension HabitViewController: UITextFieldDelegate {
    
    // Text field should return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        newHabitNameTextField.resignFirstResponder()
        return true
    }
}
