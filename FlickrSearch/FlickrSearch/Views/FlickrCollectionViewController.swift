//
//  FlickrCollectionViewController.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

class FlickrCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextLabel: UILabel!
    var searchTexts = [String]()
    var selected: String?
    var coreDataViewModel = CoreDataViewModel()
    private var searchBarController: UISearchController!
    private var numberOfColumns: CGFloat = FlickrConstants.defaultColumnCount
    private var viewModel = FlickrViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModelClosures()
        coreDataViewModel.getData {
            self.searchTexts = self.coreDataViewModel.searchTexts
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
extension FlickrCollectionViewController {
    fileprivate func configureUI() {
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.placeholder = "Search"
        searchTextLabel.text = FlickrConstants.firstSearchText
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: PhotoCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: PhotoCollectionViewCell.nibName)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    fileprivate func hideCollectionView() {
        self.tableView.isHidden = false
        self.collectionView.isHidden = true
    }
    fileprivate func hideTableView() {
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
    }
}
extension FlickrCollectionViewController {
    fileprivate func viewModelClosures() {
        searchPhotos(FlickrConstants.firstSearchText)
        dataUpdated()
    }
    private func searchPhotos(_ searchText: String) {
        viewModel.searchPhotos(text: searchText) {
            print("initial data load.")
        }
    }
    private func dataUpdated() {
        viewModel.dataUpdated = { [weak self] in
            print("data updated")
            self?.collectionView.reloadData()
        }
    }
    private func loadNextPage() {
        viewModel.fetchNextPhotos {
            print("next photos fetched")
        }
    }
}

extension FlickrCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTexts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchTexts[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedText = searchTexts[indexPath.row]
        selected = selectedText
        searchPhotos(selected!)
        searchTextLabel.text = selectedText
        dataUpdated()
        hideTableView()
    }
}

extension FlickrCollectionViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.reloadData()

        if !searchText.isNullOrEmpty() {
            searchPhotos(searchText)
            searchTextLabel.text = searchText
            hideTableView()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchTexts.count > 1 {
            hideCollectionView()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.tableView.reloadData()
        hideTableView()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > FlickrConstants.searchTextCharCount else {
            return
        }
        if !text.isNullOrEmpty() {
            collectionView.reloadData()
            searchTexts.append(text)
            searchTextLabel.text = text
            coreDataViewModel.setData(searchText: text)
            tableView.reloadData()
            hideTableView()
            searchPhotos(text)
        }
        searchBar.resignFirstResponder()
    }
}

extension FlickrCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
                         -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.nibName, for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = nil
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else {
            return
        }
        let model = viewModel.photoArray[indexPath.row]
        cell.model = PhotoModel.init(withPhotos: model)
        if indexPath.row == (viewModel.photoArray.count - 10) {
            loadNextPage()
        }
    }
}

extension FlickrCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/numberOfColumns,
               height: (collectionView.bounds.width)/numberOfColumns)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
