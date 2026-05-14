import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Constants
    
    // MARK: - State
    
    private var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    
    // MARK: - Dependencies
    
    private var questionFactory: QuestionFactoryProtocol?
    private let alertPresenter: AlertPresenter = AlertPresenter()
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter: MovieQuizPresenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        
        presenter.viewController = self
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        reloadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.handleAnswer(true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.handleAnswer(false)
    }
    
    // MARK: - Private Methods
    
    private func makeQuizResultViewModel() -> QuizResultViewModel {
        let bestGame = statisticService.bestGame
        let text = """
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        return QuizResultViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
    }

    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = 0
        
        presenter.isAnswerProcessing = false
        setButtonsEnabled(true)
    }
    
    private func show(quiz result: QuizResultViewModel) {
        let model = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                
                self.restartQuiz()
            }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        
        setButtonsEnabled(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if presenter.isLastQuestion() {
            statisticService.store(
                correctAnswers: correctAnswers,
                questionsAmount: presenter.questionsAmount)
            
            let viewModel = makeQuizResultViewModel()
            show(quiz: viewModel)
            
        } else {
            presenter.switchToNextQuestion()
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func restartQuiz() {
        correctAnswers = 0
        presenter.resetQuestionIndex()
        
        questionFactory?.requestNextQuestion()
    }

    private func reloadData() {
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.reloadData()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    
}
