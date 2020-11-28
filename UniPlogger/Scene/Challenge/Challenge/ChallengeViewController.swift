//
//  ChallengeViewController.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/10/26.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SnapKit
import Then

protocol ChallengeDisplayLogic: class {
    func displaySomething(viewModel: Challenge.Something.ViewModel)
}

class ChallengeViewController: UIViewController, ChallengeDisplayLogic {
    var interactor: ChallengeBusinessLogic?
    var router: (NSObjectProtocol & ChallengeRoutingLogic & ChallengeDataPassing)?
    
    lazy var backgroundImageView = UIImageView().then {
        let image = UIImage(named: "challengeBackground")
        $0.image = image!.resizeTopAlignedToFill(newWidth: self.view.frame.width)
        $0.contentMode = .top
        $0.clipsToBounds = true
    }
    lazy var weekLabel = UILabel().then {
        $0.font = .notoSans(ofSize: 20, weight: .bold)
        $0.text = interactor?.setDate()
        $0.textAlignment = .center
    }
    lazy var infoButton = UIButton().then {
        $0.setImage(UIImage(named: "challenge_info"), for: .normal)
        $0.addTarget(self, action: #selector(touchUpInfoButton), for: .touchUpInside)
    }
    lazy var firstRankView = TopRankView()
    lazy var secondRankView = TopRankView()
    lazy var thirdRankView = TopRankView()
    lazy var rankTableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    lazy var scoreInfoView = ScoreInfoView()
    lazy var dimView = UIView().then {
        $0.backgroundColor = UIColor(named: "dimColor")
    }

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
  // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = ChallengeInteractor()
        let presenter = ChallengePresenter()
        let router = ChallengeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setUpTableView() {
        rankTableView.delegate = self
        rankTableView.dataSource = self
        rankTableView.separatorStyle = .none
        rankTableView.register(RankTableViewCell.self, forCellReuseIdentifier: "rankCell")
    }
    
  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
        setUpLayout()
        interactor?.startChallenge()
        interactor?.getPlanet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dimView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
  
    func displaySomething(viewModel: Challenge.Something.ViewModel) {
    
    }
    
    @objc func touchUpInfoButton() {
        router?.routeToScoreInfo()
    }
}

extension ChallengeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = rankTableView.dequeueReusableCell(withIdentifier: "rankCell") as? RankTableViewCell else { return UITableViewCell() }
        let viewModel = Challenge.RankCellViewModel(email: "asdf@naver.com", rank: 4, nickname: "띵숙이", score: 1234)
        cell.selectionStyle = .none
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToUserLog()
    }
}
