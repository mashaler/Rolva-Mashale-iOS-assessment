import UIKit

protocol ProfilePictureDelegate: AnyObject {
    func didUpdateProfilePicture(_ image: UIImage?, for engineer: Engineer)
}

class QuestionsViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    
    weak var profilePictureDelegate: ProfilePictureDelegate?
    var selectedEngineer: Engineer?
    var questions: [Question] = []

    static func loadController(with questions: [Question]) -> QuestionsViewController {
        let viewController = QuestionsViewController.init(nibName: String.init(describing: self), bundle: Bundle(for: self))
        viewController.loadViewIfNeeded()
        viewController.setUp(with: questions)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "About"
        scrollView.delegate = self
        
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        profileView.layer.cornerRadius = 10
        profileView.layer.masksToBounds = true
        profileButton.layer.cornerRadius = profileButton.frame.size.width / 2
        profileButton.layer.masksToBounds = true
        profileView.backgroundColor = UIColor.black
        nameLabel.textColor = UIColor.white
        roleLabel.textColor = UIColor.white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    func setUp(with questions: [Question]) {
        loadViewIfNeeded()

        for question in questions {
            addQuestion(with: question)
        }

        self.questions = questions
    }

    private func addQuestion(with data: Question) {
        guard let cardView = QuestionCardView.loadView() else { return }
        cardView.setUp(with: data.questionText,
                       options: data.answerOptions,
                       selectedIndex: data.answer?.index)
        containerStack.addArrangedSubview(cardView)
    }
    
    @objc func profileButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
           let engineer = selectedEngineer {
            profileButton.setImage(selectedImage, for: .normal)
            profilePictureDelegate?.didUpdateProfilePicture(selectedImage, for: engineer)

            NotificationCenter.default.post(name: Notification.Name("ProfilePictureUpdated"), object: selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension QuestionsViewController: ProfilePictureDelegate {
    func didUpdateProfilePicture(_ image: UIImage?, for engineer: Engineer) {
        profilePictureDelegate?.didUpdateProfilePicture(image, for: engineer)
        selectedEngineer?.profileImage = image
    }
}
