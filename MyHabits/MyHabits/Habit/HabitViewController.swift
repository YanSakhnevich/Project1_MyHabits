import UIKit

class HabitViewController: UIViewController {
    
    weak var dataDelegator: UpdatingCollectionDataDelegate?

    private var habitColor: UIColor = .systemOrange
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
    
        return dateFormatter
    }()
    
    var habit: Habit?
    
    init (habit: Habit?) {
        super.init(nibName: nil, bundle: nil)
        self.habit = habit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Content
    // Name Label
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "НАЗВАНИЕ"
        nameLabel.font = .boldSystemFont(ofSize: 13)
        
        return nameLabel
    }()
    
    // Name of new habit Text Field
    private let newHabitNameTextField: UITextField = {
        let newHabitNameTextField = UITextField()
        newHabitNameTextField.font = .systemFont(ofSize: 17)
        newHabitNameTextField.textColor = UIColor(named: "CustomBlue") ?? .systemBlue
        newHabitNameTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        newHabitNameTextField.returnKeyType = .done
        
        return newHabitNameTextField
    }()
    
    // Color Label
    private let colorLabel: UILabel = {
        let colorLabel = UILabel()
        colorLabel.text = "ЦВЕТ"
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
        
        newHabitColorPickerButton.backgroundColor = UIColor(named: "CustomOrange") ?? .systemOrange
        
        newHabitColorPickerButton.layer.cornerRadius = 15
        
        newHabitColorPickerButton.isUserInteractionEnabled = true
        newHabitColorPickerButton.addTarget(self, action: #selector(didTappedOnColorPicker), for: .touchUpInside)
        
        return newHabitColorPickerButton
    }()
    
    // Time Label
    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "ВРЕМЯ"
        timeLabel.font = .boldSystemFont(ofSize: 13)
        
        return timeLabel
    }()
    
    // New habit time text (text part)
    private let newHabitTimeTextLabel: UILabel = {
        let newHabitTimeTextLabel = UILabel()
        newHabitTimeTextLabel.text = "Каждый день в "
        
        return newHabitTimeTextLabel
    }()
    
    // New habit time text (time part)
    private let newHabitTimeDateLabel: UILabel = {
        let newHabitTimeDateLabel = UILabel()
        newHabitTimeDateLabel.textColor = UIColor(named: "CustomPurple")
        
        return newHabitTimeDateLabel
    }()
    
    
    // New habit Time Picker
    private let newHabitTimeDatePicker: UIDatePicker = {
        let newHabitTimeDatePicker = UIDatePicker()
        newHabitTimeDatePicker.datePickerMode = .time
        newHabitTimeDatePicker.preferredDatePickerStyle = .wheels
        newHabitTimeDatePicker.locale = Locale(identifier: "en_US")
        
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
        
        
        setupNavBar()
        
        
        setupViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
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
            newHabitTimeDatePicker
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
            newHabitTimeDatePicker.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // Setup navigation bar
    private func setupNavBar() {

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .init(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTabBarButtonPressed))
        navigationItem.rightBarButtonItem?.style = .done

        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CustomPurple") ?? .systemPurple
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelTabBarButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "CustomPurple") ?? .systemPurple
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = .white
        title = "Создать"

    }
    
    // MARK: - Actions
    // Saving new habit
    @objc func saveTabBarButtonPressed(_ sender: UIBarButtonItem) {
        
        if ((newHabitNameTextField.text?.isEmpty) != Optional(false)) { newHabitNameTextField.text = "Тут должно быть что-то грандиозное (но вы не указали что...)"
        }
        
        let newHabit = Habit(
            name: newHabitNameTextField.text ?? "NO DATA",
            date: newHabitTimeDatePicker.date,
            color: habitColor
        )
        let store = HabitsStore.shared
        store.habits.append(newHabit)
        reloadInputViews()
        
        navigationController?.popViewController(animated: true)
            self.dataDelegator?.updateCollection()
        
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
