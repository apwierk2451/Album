//
//  AlbumListView.swift
//  Album
//
//  Created by 이은찬 on 2023/02/06.
//

import UIKit

final class AlbumListView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        self.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.identifier)
        self.rowHeight = 85
    }
}
