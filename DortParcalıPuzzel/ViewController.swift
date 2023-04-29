//
//  ViewController.swift
//  DortParcalıPuzzel
//
//  Created by Ebrar Etiz on 26.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var emptyCellIndexPath: IndexPath?

    var pieces:[UIImage?] = [UIImage]()
    let imageNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tasarım:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genişlik = self.collectionView.frame.size.width
        tasarım.sectionInset = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)
        tasarım.itemSize = CGSize(width: (genişlik-30)/4, height: (genişlik-30)/4)
        tasarım.minimumInteritemSpacing = 0
        tasarım.minimumLineSpacing = 0
        collectionView.collectionViewLayout = tasarım
        
        
        for imageName in imageNames {
             let image = UIImage(named: imageName)
             pieces.append(image)
         }
        //pieces.shuffle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = true


        
    }


}

extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pieces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "puzzelHucre", for: indexPath) as! CollectionViewHucre
               
           cell.PuzzelImageView.image = pieces[indexPath.row]

           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
           cell.addGestureRecognizer(panGesture)

           return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("seçim yapıldı")
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceIndex = sourceIndexPath.item
            let destinationIndex = destinationIndexPath.item
            
            let temp = pieces[sourceIndex]
            pieces[sourceIndex] = pieces[destinationIndex]
            pieces[destinationIndex] = temp
            
            collectionView.reloadData()

    }
    
    @IBAction func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewHucre else { return }
        
        switch recognizer.state {
        case .began:
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        case .changed:
            cell.center = recognizer.location(in: collectionView)
        case .ended:
            let cellCenter = collectionView.convert(cell.center, to: collectionView.superview)
            let emptyCellIndexPath = findEmptyCellIndexPath()
            guard let newIndexPath = emptyCellIndexPath, newIndexPath != indexPath else {
                UIView.animate(withDuration: 0.2, animations: {
                    cell.transform = CGAffineTransform.identity
                    cell.center = self.collectionView.cellForItem(at: indexPath)?.center ?? cell.center
                })
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform.identity
                cell.center = self.collectionView.cellForItem(at: newIndexPath)?.center ?? cell.center
            })
            
            let temp = pieces[indexPath.row]
            pieces[indexPath.row] = pieces[newIndexPath.row]
            pieces[newIndexPath.row] = temp
            
            collectionView.reloadData()
        default:
            break
        }
    }

    func findEmptyCellIndexPath() -> IndexPath? {
        for (index, piece) in pieces.enumerated() {
            if piece == nil {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }
    
    
    /*
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard let emptyIndexPath = emptyCellIndexPath else { return }
            
            let location = gestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                if indexPath != emptyIndexPath {
                    // Boş hücreyi taşı
                    collectionView.performBatchUpdates({
                        collectionView.moveItem(at: emptyIndexPath, to: indexPath)
                        emptyCellIndexPath = indexPath
                    })
                }
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
           return collectionView.cellForItem(at: indexPath) == nil
       }
*/
}
