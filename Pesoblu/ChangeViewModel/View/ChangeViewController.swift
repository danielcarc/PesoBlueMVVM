//
//  CurrencyViewController.swift
//  PesoBlueMVVM
//
//  Created by Daniel Francisco Carcacha on 29/09/23.
//

import UIKit

class ChangeViewController: UIViewController {
    
    
    private var viewModel = ChangeViewModel()
    
    private lazy var collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 171)
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //registramos la celda
        vw.register(ChangeCollectionViewCell.self, forCellWithReuseIdentifier: "ChangeCollectionViewCell")
        
        vw.dataSource = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    private lazy var rightButtonBar = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupBtn()
        viewModel.getChange()
        setTitle()
        setDelegate()
        
    }
}

//MARK: - Setup Button and CollectionView
extension ChangeViewController{
    func setupBtn(){
        rightButtonBar.setTitle("Ir a Calcular", for: .normal)
        rightButtonBar.addTarget(self, action: #selector(goToCurrencyVC), for: .touchUpInside)
        rightButtonBar.setTitleColor(UIColor(red: 87/255, green: 147/255, blue: 215/255, alpha: 1), for:.normal)
        rightButtonBar.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
}


//MARK: - Setup CollectionView

private extension ChangeViewController{
    func setup(){
        
        view.backgroundColor = .white
        self.view.addSubview(collectionView)
        let barButtonItem = UIBarButtonItem(customView: rightButtonBar)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ChangeViewController{
    func setDelegate(){
        viewModel.delegate = self
    }
    func setTitle(){
        title = "Cotizaciones"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: - Button Method

extension ChangeViewController{
    
    @objc func goToCurrencyVC(){
        //let nextScreen = CurrencyConverterViewController()
        //self.navigationController?.pushViewController(nextScreen, animated: true)
    }
}


//MARK: - ChangeViewModelDelegate Methods

extension ChangeViewController: ChangeViewModelDelegate{
    func didFinish() {
        collectionView.reloadData()
    }
    
    func didFail(error: Error) {
        print(error)
    }
}

//MARK: - CollectionView DataSource Methods

extension ChangeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.changes.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.changes[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChangeCollectionViewCell", for: indexPath) as! ChangeCollectionViewCell

        cell.item = item
        
        return cell
    }
}

#Preview("ChangeViewController", traits: .defaultLayout, body: { ChangeViewController()})

