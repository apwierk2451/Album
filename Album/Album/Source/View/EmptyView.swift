//
//  EmptyView.swift
//  Album
//
//  Created by 이은찬 on 2023/02/07.
//

import UIKit

final class EmptyView: UIView {
    
    private enum EmptyViewNameSpace {
        static let defaultText = "사진 또는 비디오 없음"
    }
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = EmptyViewNameSpace.defaultText
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder :)")
    }
    
    required init() {
        super.init(frame: .zero)
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    private func setupDefault() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addUIComponents() {
        addSubview(title)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
