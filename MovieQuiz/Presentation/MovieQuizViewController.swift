import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
        
    // MARK: - Dependencies
    private let alertPresenter: AlertPresenter = AlertPresenter()
    private lazy var presenter: MovieQuizPresenterProtocol = MovieQuizPresenter(view: self)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        reloadData()
    }
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.didAnswer(true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.didAnswer(false)
    }
    
    // MARK: - Private Methods

    private func reloadData() {
        showLoadingIndicator()
        presenter.loadData()
    }
}

// MARK: - MovieQuizView

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    func showQuestion(_ viewModel: QuizStepViewModel) {
        imageView.image = UIImage(data: viewModel.image) ?? UIImage()
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
        
        imageView.layer.borderWidth = 0
    }

    func showResult(_ viewModel: QuizResultViewModel) {
        let model = AlertModel(
            title: viewModel.title,
            message: viewModel.text,
            buttonText: viewModel.buttonText) { [weak self] in
                guard let self = self else { return }
                
                presenter.restartQuiz()
            }
        
        alertPresenter.show(in: self, model: model)
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.reloadData()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func highlightAnswer(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
    }
    
    func setAnswerButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
}
