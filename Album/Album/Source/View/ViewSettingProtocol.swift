//
//  ViewSettingProtocol.swift
//  Album
//
//  Created by 이은찬 on 2023/02/07.
//

import UIKit

protocol ViewSettingProtocol {
    
    init()
    
    func setupDefault()
    func addUIComponents()
    func setupLayout()
}

class SuperViewControllerSetting: UIViewController , ViewSettingProtocol {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder :)")
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupDefault()
        addUIComponents()
        setupLayout()
    }
    
    func setupDefault() { }
    func addUIComponents() { }
    func setupLayout() { }
}
