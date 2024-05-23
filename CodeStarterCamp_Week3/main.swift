//
//  main.swift
//  CodeStarterCamp_Week3
//
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class Person {
    let name: String
    let job: String
    var money: Int
    var coffeeOnHand = [Coffee]()
    
    init(name: String, job: String, money: Int) {
        self.name = name
        self.job = job
        self.money = money
    }
    
    func orderCoffee(with coffeeList: [Coffee], at coffeeShop: CoffeeShop, by name: String) {
        var order = [Coffee]()
        for coffee in coffeeList {
            guard let price = coffeeShop.menu[coffee] else { return }
            if money - price >= 0 {
                money -= price
                order.append(coffee)
            } else {
                print("잔액이 \(money - price)만큼 부족합니다.")
            }
        }
        if !order.isEmpty {
            coffeeShop.takeOrder(coffeeList: order, orderer: name) { completedOrders in
                receiveCoffee(order: completedOrders)
            }
        } else {
            return
        }
    }
    
    private func receiveCoffee(order: [Coffee]) {
        print("감사합니다~^^")
        coffeeOnHand = order
        drinkCoffee()
    }
    
    private func drinkCoffee() {
        print("홀짝")
        coffeeOnHand.removeAll()
    }
}

class CoffeeShop {
    let name: String
    var sales: Int
    let barista: Person
    let menu: [Coffee: Int]
    var pickUpTable = [Coffee]()
    
    init(name: String, sales: Int, barista: Person, menu: [Coffee: Int]) {
        self.name = name
        self.sales = sales
        self.barista = barista
        self.menu = menu
    }
    
    func takeOrder(coffeeList: [Coffee], orderer: String, completionHandler: ([Coffee]) -> Void) {
        for coffee in coffeeList {
            if let price = menu[coffee] {
                sales += price
            }
            pickUpTable.append(coffee)
        }
        makeCoffee(orderer: orderer, completionHandler: completionHandler)
    }
    
    private func makeCoffee(orderer: String, completionHandler: ([Coffee]) -> Void) {
        let completedOrders = pickUpTable.map { $0.rawValue }.joined(separator: ", ")
        print("\(orderer) 님이 주문하신 \(completedOrders)(이/가) 준비되었습니다. 픽업대에서 가져가주세요.")
        completionHandler(pickUpTable)
        pickUpTable.removeAll()
    }
}

enum Coffee: String {
    case espresso, americano, caffeLatte, vanillaLatte
}

let misterLee = Person(name: "misterLee", job: "barista", money: 100_000)
let missKim = Person(name: "missKim", job: "student", money: 10_000)
let yagombucks = CoffeeShop(name: "yagombucks", sales: 500_000, barista: misterLee, menu: [.espresso: 4_000, .americano: 4_500, .caffeLatte: 5_000, .vanillaLatte: 5_500])

missKim.orderCoffee(with: [.espresso, .caffeLatte], at: yagombucks, by: "missKim")
