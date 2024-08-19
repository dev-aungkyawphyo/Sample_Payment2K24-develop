//
//  ViewController.swift
//  Sample_Payment2K24
//
//  Created by Aung Kyaw Phyo on 28/07/2024.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userAmountLabel: UILabel!
    @IBOutlet weak var posterCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var visibleButton: UIButton!
    
    // MARK: Properties
    var account: Account!
    var timer: Timer?
    var currentIndex = 0
    
    private var productPoster: [ProductPoster] = [
        .init(poster: UIImage(named: "poster1")!),
        .init(poster: UIImage(named: "poster2")!),
        .init(poster: UIImage(named: "poster3")!),
        .init(poster: UIImage(named: "poster4")!),
        .init(poster: UIImage(named: "poster5")!),
        .init(poster: UIImage(named: "poster6")!),
        .init(poster: UIImage(named: "poster7")!)
    ]
    
    private var recent: [HistoryRecent] = [
        .init(transfer: Transfer(recent: RecentNumber(icon: UIImage(named: "money-transfer-2")!, description: "2 August 2024, 10:42 AM"), title: "Registration Bonus"), amount: 500),
    ]

    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetup()
    }

    private func defaultSetup() {
        account = Bank.currentAccount!
        configureUI()
        collectionViewSetup()
        tableViewSetup()
        registerSetup()
        pageControl.numberOfPages = productPoster.count
        startTimer()
        addVisibleButton()
    }
    
    private func configureUI() {
        usernameLabel.text = String("Hello, \(account.username)")
        userAmountLabel.text = String("\(account.amount) MMK")
    }
    
    private func collectionViewSetup() {
        posterCollectionView.delegate = self
        posterCollectionView.dataSource = self
    }
    
    private func tableViewSetup() {
        historyTable.delegate = self
        historyTable.dataSource = self
    }
    
    private func registerSetup() {
        historyTable.register(UINib(nibName: HistoryTableViewCell.identifier, bundle: nil),
                              forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }
    
    private func addVisibleButton() {
        visibleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        visibleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        visibleButton.addTarget(self, action: #selector(addVisibleBtnTapped(_:)), for: .touchUpInside)
    }
    
    @objc func addVisibleBtnTapped(_ button: UIButton) {
        if button.isSelected == true {
            button.isSelected = false
            userAmountLabel.text = String("\(account.amount) MMK")
        } else {
            button.isSelected = true
            let str = "* * * * * *"
            userAmountLabel.text = str
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToIndex), userInfo: nil, repeats: true)
    }
    
    @objc func moveToIndex() {
        if currentIndex < productPoster.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        posterCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0),
                                          at: .centeredHorizontally,
                                          animated: true)
        pageControl.currentPage = currentIndex
    }
  
}

// MARK: Extension
/**
 - Documentation for purpose of extension
 */

// MARK: UICollectionViewDelegate
extension HomeScreenViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDataSource
extension HomeScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productPoster.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.posterSetup(poster: productPoster[indexPath.row])
        return cell
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: UITableViewDelegate
extension HomeScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Need action
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
 
// MARK: UITableViewDataSource
extension HomeScreenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recent.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.setupHistoryRecent(recent: recent[indexPath.section])
        return cell
    }
    
}

extension HomeScreenViewController: HomeScreenProtocols {
    
    func topupRouter() {
        let vc = TopUpScreenViewController.instantiate(name: .TopUpScreenViewController)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func transferRouter() {
        let vc = TransferScreenViewController.instantiate(name: .TransferScreenViewController)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func cashInRouter() {
        let vc = CashInScreenViewController.instantiate(name: .CashInScreenViewController)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func cashOutRouter() {
        let vc = CashOutScreenViewController.instantiate(name: .CashOutScreenViewcontroller)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

// MARK: - User Interaction - Actions & Targets
extension HomeScreenViewController {
    
    @IBAction func didTappedTopUpBtn(_ sender: UIButton) {
        topupRouter()
    }
    
    @IBAction func didTappedTransferBtn(_ sender: UIButton) {
        transferRouter()
    }
    
    @IBAction func didTappedCashInBtn(_ sender: UIButton) {
        cashInRouter()
    }
    
    @IBAction func didTappedCashOutBtn(_ sender: UIButton) {
        cashOutRouter()
    }
    
}
