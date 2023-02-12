//
//  ViewPresenter.swift
//  TraineeshipApp
//
//  Created by Vadim Blagodarny on 12.02.2023.
//

import Foundation
import UIKit

protocol ViewProtocol {
    func setupView()
    func setupConstraints()
    func sendRequestButtonTap()
}

protocol ViewPresenterProtocol {
    var carouselStrings: [String] { get set }
    var buttonStates: [String: Bool] { get set }
    
    init(view: ViewProtocol)
    
    func moveItemLeft(item: String, at indexPath: IndexPath)
    func moveItemRight(item: String, at indexPath: IndexPath)
}

class ViewPresenter: ViewPresenterProtocol {
    let view: ViewProtocol
    var carouselStrings: [String]
    var buttonStates: [String: Bool]
    
    required init(view: ViewProtocol) {
        self.view = view
        self.carouselStrings = ["IOS", "Android", "Design", "QA", "Flutter", "PM", "Frontend", "Backend", "CJM", "Web"]
        self.buttonStates = [:]
        self.carouselStrings.forEach { title in
            self.buttonStates[title] = false
        }
    }
    
    func moveItemLeft(item: String, at indexPath: IndexPath) {
        let itemToMove = self.carouselStrings.remove(at: indexPath.row)
        self.carouselStrings.insert(itemToMove, at: 0)
    }
    
    func moveItemRight(item: String, at indexPath: IndexPath) {
        let itemToMove = self.carouselStrings.remove(at: indexPath.row)
        self.carouselStrings.append(itemToMove)
    }
}
