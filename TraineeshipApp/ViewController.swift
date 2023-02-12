//
//  ViewController.swift
//  TraineeshipApp
//
//  Created by Vadim Blagodarny on 08.02.2023.
//

import UIKit

class ViewController: UIViewController, ViewProtocol {
    var presenter: ViewPresenterProtocol!
    
    let cellId = "CellId"

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Resources.Image.background)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: Область с контентом
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resources.Colors.backgroundColor
        view.layer.cornerRadius = 32
        view.addSubview(traineeShipHeaderLabel)
        view.addSubview(traineeShipDescriptionOneLabel)
        view.addSubview(carouselOneCollectionView)
        return view
    }()
    
    private lazy var traineeShipHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Resources.Text.traineeShipHeaderText
        label.font = Resources.Fonts.sfProDisplay2432Bold
        label.textColor = Resources.Colors.textBlackColor
        return label
    }()

    private lazy var traineeShipDescriptionOneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Resources.Text.traineeShipDescriptionOneText
        label.font = Resources.Fonts.sfProDisplay1420Regular
        label.textColor = Resources.Colors.textGrayColor
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.lineHeight = 20
        return label
    }()

    private lazy var carouselOneCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 6
        layout.sectionInset.right = layout.itemSize.width / 1.33 // Временное решение по багу с обрезкой хвоста CV
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: Основной UIScrollView
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(contentsView)
        return scrollView
    }()
    
    // MARK: Нижний фрейм и его элементы

    private lazy var subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wantToJoinLabel)
        view.addSubview(sendRequestButton)
        return view
    }()
    
    private lazy var sendRequestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Resources.Text.sendRequestButtonText, for: .normal)
        button.setTitleColor(Resources.Colors.buttonActiveTextColor, for: .normal)
        button.titleLabel?.font = Resources.Fonts.sfProDisplay1620Medium
        button.layer.cornerRadius = 32
        button.backgroundColor = Resources.Colors.buttonActiveBackground
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
        button.addTarget(self, action: #selector(sendRequestButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var wantToJoinLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Resources.Text.wantToJoinText
        label.font = Resources.Fonts.sfProDisplay1420Medium
        label.textColor = Resources.Colors.textGrayColor
        return label
    }()

    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(subView)
    }
    
    func setupConstraints() {
        
        // MARK: Констрейнты нижнего фрейма и элементов
        subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -58).isActive = true
        subView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        wantToJoinLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        wantToJoinLabel.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -20).isActive = true
        wantToJoinLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor).isActive = true

        sendRequestButton.bottomAnchor.constraint(equalTo: subView.bottomAnchor).isActive = true
        sendRequestButton.trailingAnchor.constraint(equalTo: subView.trailingAnchor).isActive = true
        sendRequestButton.widthAnchor.constraint(equalToConstant: 219).isActive = true
        sendRequestButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        // MARK: Констрейнты основного UIScrollView и элементов
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: subView.topAnchor).isActive = true
        
        backgroundImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        // MARK: Констрейнты для области контента
        contentsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentsView.heightAnchor.constraint(equalToConstant: 216).isActive = true
        contentsView.bottomAnchor.constraint(equalTo: subView.topAnchor).isActive = true

        traineeShipHeaderLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 20).isActive = true
        traineeShipHeaderLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentsView.trailingAnchor, constant: -20).isActive = true
        traineeShipHeaderLabel.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 24).isActive = true
        
        traineeShipDescriptionOneLabel.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 20).isActive = true
        traineeShipDescriptionOneLabel.widthAnchor.constraint(equalTo: contentsView.widthAnchor, constant: -40).isActive = true
        traineeShipDescriptionOneLabel.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -20).isActive = true
        traineeShipDescriptionOneLabel.topAnchor.constraint(equalTo: traineeShipHeaderLabel.bottomAnchor, constant: 12).isActive = true
        
        carouselOneCollectionView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor, constant: 20).isActive = true
        carouselOneCollectionView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -20).isActive = true
        carouselOneCollectionView.topAnchor.constraint(equalTo: traineeShipDescriptionOneLabel.bottomAnchor, constant: 12).isActive = true
        carouselOneCollectionView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @objc func sendRequestButtonTap() {
        let alert = UIAlertController(title: Resources.Text.alertTitle,
                                      message: Resources.Text.alertText,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Resources.Text.alertClose, style: .default))
        self.present(alert, animated: true)
    }
}

extension UILabel { // Настройка высоты строки
    public var lineHeight: CGFloat? {
        get { nil }
        set {
            let lineHeight = newValue ?? font.lineHeight
            let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / 2.0

            let mutableParagraphStyle = NSMutableParagraphStyle()
            mutableParagraphStyle.minimumLineHeight = lineHeight
            mutableParagraphStyle.maximumLineHeight = lineHeight

            attributedText = NSAttributedString(
                string: text ?? "",
                attributes: [
                    .baselineOffset : baselineOffset,
                    .paragraphStyle : mutableParagraphStyle
                ]
            )
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
        let item = cell.toggleButton() // Изменили Press State и вернули имя кнопки
        presenter.buttonStates[item]!.toggle() // Обновили Press State в словаре

        switch presenter.buttonStates[item]! {
        case true: // Двигаем кпопку влево
            collectionView.moveItem(at: indexPath, to: IndexPath(row: 0, section: 0))
            presenter.moveItemLeft(item: item, at: indexPath)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: true)
        case false: // Двигаем кпопку вправо
            collectionView.moveItem(at: indexPath, to: IndexPath(row: collectionView.numberOfItems(inSection: 0) - 1, section: 0))
            presenter.moveItemRight(item: item, at: indexPath)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.carouselStrings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        let title = presenter.carouselStrings[indexPath.row]
        let isSelected = presenter.buttonStates[title]!
        cell.configure(title: title, isSelected: isSelected)
        return cell
    }
}
