//
//  PerfilViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 21/07/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    let image = UIImageView()
    
    let control = UIControl()
    
    let scrollView = UIScrollView()
    
    let inicialHeight = 50
    
    let solicitationTableView = UITableView()
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        
        super.viewDidLoad()
        scrollView.frame = self.view.frame
        scrollView.frame.size.height -= self.tabBarController?.tabBar.frame.height ?? 83
        print(scrollView.frame)
        print(scrollView.contentSize)
        
        
        image.frame = CGRect(x: 131, y: 145, width: 152, height: 152)
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.frame.height/2
        
        let menuLabel = UILabel(frame: CGRect(x: 83, y: 56, width: 248, height: 62))
        menuLabel.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        menuLabel.font = menuLabel.font.withSize(50)
        menuLabel.text = "Menu"
        menuLabel.textAlignment = .center

        scrollView.addSubview(menuLabel)
        scrollView.addSubview(control)
        scrollView.addSubview(image)
        view.addSubview(scrollView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.contentSize = scrollView.frame.size
        
        DispatchQueue.global(qos: .background).async {
            
            if let imageURL = userProdutor!.imageURL{
                
                
                let url = NSURL(string: imageURL)
                let data = NSData(contentsOf: url! as URL)
                if data != nil {
                    userProdutor!.image = UIImage(data: data! as Data)
                    
                    DispatchQueue.main.async {
                        self.image.image = userProdutor!.image
                        
                    }
                }
            }
        }
        
        control.frame = CGRect(x: 20, y: 557, width: 374, height: 50)
        control.addTarget(self, action: #selector(solicitationsButton), for: .touchUpInside)
        control.layer.masksToBounds = true
        control.layer.cornerRadius = 10
        control.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let label = UILabel(frame: CGRect(x: 5, y: 10, width: 200, height: 30))
        label.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        label.text = "Ver solicitações (\(userProdutor!.solicitations.count))"
        control.addSubview(label)
    }
    
    @objc func solicitationsButton(){
        
        control.removeTarget(nil, action: nil, for: .touchUpInside)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.control.frame.size.height += CGFloat(userProdutor!.solicitations.count)*200
        }, completion: nil)
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.height + 10
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
