//
//  DetailTableViewController.swift
//  SmartOrder
//
//  Created by Lu Kevin on 2018/11/19.
//  Copyright © 2018年 Eason. All rights reserved.
//

import UIKit


class DetailTableViewController: UITableViewController {

    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    var menuSelectedNumber = 0
    var detailImageNumber = 0
    var currentPrice = ""
    
    
    var hamburgerImages = ["牛肉漢堡","雞肉漢堡","豬肉漢堡"]
    var hamburgerName = ["牛肉漢堡","雞肉漢堡","豬肉漢堡"]
    var hamburgurPrice = ["70","80","90"]
    
    var spaghettiImages = ["紅醬義大利麵","青醬義大利麵","白醬義大利麵"]
    var spaghettiName = ["紅醬義大利麵","青醬義大利麵","白醬義大利麵"]
    var spaghettiPrice = ["70","80","90"]
    
    
    var pizzaImages = ["起司披薩","番茄披薩","橄欖披薩"]
    var pizzaName = ["起司披薩","番茄披薩","橄欖披薩"]
    var pizzaPrice = ["70","80","90"]
    
    
    var steakImages = ["牛菲力","牛肋排","炙燒牛排"]
    var steakName = ["牛菲力","牛肋排","炙燒牛排"]
    var steakPrice = ["70","80","90"]
    
    
    var dessertImages = ["馬卡龍","巧克力蛋糕","聖代"]
    var dessertName = ["馬卡龍","巧克力蛋糕","聖代"]
    var dessertPrice = ["70","80","90"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        switch menuSelectedNumber {
            
        case 0:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: hamburgerImages[detailImageNumber])
                detailPrice.text? = hamburgurPrice[detailImageNumber]
                currentPrice = hamburgurPrice[detailImageNumber]
                resultItem = hamburgerName[detailImageNumber]
                resultPrice = hamburgurPrice[detailImageNumber]
                
                
            case 1:
                detailImage.image = UIImage(named: hamburgerImages[detailImageNumber])
                detailPrice.text? = hamburgurPrice[detailImageNumber]
                currentPrice = hamburgurPrice[detailImageNumber]
                resultItem = hamburgerName[detailImageNumber]
                resultPrice = hamburgurPrice[detailImageNumber]


            case 2:
                detailImage.image = UIImage(named: hamburgerImages[detailImageNumber])
                detailPrice.text? = hamburgurPrice[detailImageNumber]
                currentPrice = hamburgurPrice[detailImageNumber]
                resultItem = hamburgerName[detailImageNumber]
                resultPrice = hamburgurPrice[detailImageNumber]


            default:
                break
            }
            
            
        case 1:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: spaghettiImages[detailImageNumber])
                detailPrice.text? = spaghettiPrice[detailImageNumber]
                currentPrice = spaghettiPrice[detailImageNumber]
                resultItem = spaghettiName[detailImageNumber]
                resultPrice = spaghettiPrice[detailImageNumber]


            case 1:
                detailImage.image = UIImage(named: spaghettiImages[detailImageNumber])
                detailPrice.text? = spaghettiPrice[detailImageNumber]
                currentPrice = spaghettiPrice[detailImageNumber]
                resultItem = spaghettiName[detailImageNumber]
                resultPrice = spaghettiPrice[detailImageNumber]



            case 2:
                detailImage.image = UIImage(named: spaghettiImages[detailImageNumber])
                detailPrice.text? = spaghettiPrice[detailImageNumber]
                currentPrice = spaghettiPrice[detailImageNumber]
                resultItem = spaghettiName[detailImageNumber]
                resultPrice = spaghettiPrice[detailImageNumber]


            default:
                break
            }
        
        case 2:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: pizzaImages[detailImageNumber])
                detailPrice.text? = pizzaPrice[detailImageNumber]
                currentPrice = pizzaPrice[detailImageNumber]
                resultItem = pizzaName[detailImageNumber]
                resultPrice = pizzaPrice[detailImageNumber]


            case 1:
                detailImage.image = UIImage(named: pizzaImages[detailImageNumber])
                detailPrice.text? = pizzaPrice[detailImageNumber]
                currentPrice = pizzaPrice[detailImageNumber]
                resultItem = pizzaName[detailImageNumber]
                resultPrice = pizzaPrice[detailImageNumber]

                
            case 2:
                detailImage.image = UIImage(named: pizzaImages[detailImageNumber])
                detailPrice.text? = pizzaPrice[detailImageNumber]
                currentPrice = pizzaPrice[detailImageNumber]
                resultItem = pizzaName[detailImageNumber]
                resultPrice = pizzaPrice[detailImageNumber]


            default:
                break
            }
            
        case 3:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: steakImages[detailImageNumber])
                detailPrice.text? = steakPrice[detailImageNumber]
                currentPrice = steakPrice[detailImageNumber]
                resultItem = steakName[detailImageNumber]
                resultPrice = steakPrice[detailImageNumber]


            case 1:
                detailImage.image = UIImage(named: steakImages[detailImageNumber])
                detailPrice.text? = steakPrice[detailImageNumber]
                currentPrice = steakPrice[detailImageNumber]
                resultItem = steakName[detailImageNumber]
                resultPrice = steakPrice[detailImageNumber]



            case 2:
                detailImage.image = UIImage(named: steakImages[detailImageNumber])
                detailPrice.text? = steakPrice[detailImageNumber]
                currentPrice = steakPrice[detailImageNumber]
                resultItem = steakName[detailImageNumber]
                resultPrice = steakPrice[detailImageNumber]

                
            default:
                break
            }
            
        case 4:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: dessertImages[detailImageNumber])
                detailPrice.text? = dessertPrice[detailImageNumber]
                currentPrice = dessertPrice[detailImageNumber]
                resultItem = dessertName[detailImageNumber]
                resultPrice = dessertPrice[detailImageNumber]


            case 1:
                detailImage.image = UIImage(named: dessertImages[detailImageNumber])
                detailPrice.text? = dessertPrice[detailImageNumber]
                currentPrice = dessertPrice[detailImageNumber]
                resultItem = dessertName[detailImageNumber]
                resultPrice = dessertPrice[detailImageNumber]


            case 2:
                detailImage.image = UIImage(named: dessertImages[detailImageNumber])
                detailPrice.text? = dessertPrice[detailImageNumber]
                currentPrice = dessertPrice[detailImageNumber]
                resultItem = dessertName[detailImageNumber]
                resultPrice = dessertPrice[detailImageNumber]



            default:
                break
            }
        
            
        default:
            break
        }
    }
    
    @IBOutlet weak var stepperCount: UILabel!
    var resultPrice = ""
    var resultCount = "1"
    var resultItem = ""
    
    @IBAction func stepper(_ sender: UIStepper)  {
    
        let count = Int(sender.value)
        resultCount = String(count)
        
        stepperCount.text = String(count)
        
        let price = Int(currentPrice)!
        resultPrice = String(price * count)
        detailPrice?.text = resultPrice
    
    }
    
    
    var addDict =  [String: [String]]()
    let myUserDefaults = UserDefaults.standard
    
    @IBAction func addToOrder(_ sender: Any) {
        
        if myUserDefaults.value(forKey: "resultDict") != nil {
            
            addDict = myUserDefaults.value(forKey: "resultDict") as! [String : [String]]
            
        }  
        
        addDict.updateValue([resultCount,resultPrice], forKey: resultItem)
        myUserDefaults.setValue(addDict, forKey: "resultDict")
        print(addDict)
        
        }
    
    }


