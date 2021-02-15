//
//  ViewController.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/18/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class MatchGameViewController: UIViewController, CardViewDelegate {
    
    struct Constants{
        struct Segues{
            static let GameOver = "Game Over"
            static let Settings = "Show Settings"
        }
        struct Selectors{
            static let FlipCard:Selector = #selector(MatchGameViewController.flipCard(_:))
            static let FlipTwoCards:Selector = #selector(MatchGameViewController.flipTwoCards(_:))
            static let Show:Selector = #selector(CardView.show)
        }
    }
    
    // MARK: Private Members
    fileprivate var audioPlayer:AVAudioPlayer?
    fileprivate var cards = [CardView]()
    fileprivate var cardHeight: CGFloat { return self.cardWidth }
    fileprivate var cardsPerRow:Int {
        switch(numberOfCards){
        case (0...12):
            return 4
        case (13...30):
            return 5
        default:
            return 6
        }
    }
    fileprivate var cardWidth: CGFloat { return (view.bounds.width - (spacer * CGFloat(cardsPerRow+1))) / CGFloat(cardsPerRow) }
    fileprivate var currentCard:CardView?
    var difficulty:UserSettings.Difficulty?{
        didSet{
            reset()
        }
    }
    fileprivate var images = [
        Assets.Images.Animals.Cat:UIColor(red: 230/255, green: 164/255, blue: 174/255, alpha: 1),
        Assets.Images.Animals.Cow:UIColor(red: 177/255, green: 237/255, blue: 235/255, alpha: 1),
        Assets.Images.Animals.Deer:UIColor(red: 246/255, green: 197/255, blue: 127/255, alpha: 1),
        Assets.Images.Animals.Dog:UIColor(red: 243/255, green: 234/255, blue: 170/255, alpha: 1),
        Assets.Images.Animals.Donkey:UIColor(red: 190/255, green: 203/255, blue: 215/255, alpha: 1),
        Assets.Images.Animals.Elephant:UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1),
        Assets.Images.Animals.Fox:UIColor(red: 249/255, green: 247/255, blue: 223/255, alpha: 1),
        Assets.Images.Animals.Hen:UIColor(red: 209/255, green: 135/255, blue: 132/255, alpha: 1),
        Assets.Images.Animals.Leopard:UIColor(red: 164/255, green: 199/255, blue: 179/255, alpha: 1),
        Assets.Images.Animals.Lion:UIColor(red: 254/255, green: 242/255, blue: 118/255, alpha: 1),
        Assets.Images.Animals.Monkey:UIColor(red: 186/255, green: 162/255, blue: 150/255, alpha: 1),
        Assets.Images.Animals.Orangutan:UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1),
        Assets.Images.Animals.Owl:UIColor(red: 241/255, green: 179/255, blue: 131/255, alpha: 1),
        Assets.Images.Animals.Panda:UIColor(red: 255/255, green: 179/255, blue: 190/255, alpha: 1),
        Assets.Images.Animals.Panther:UIColor(red: 202/255, green: 233/255, blue: 201/255, alpha: 1),
        Assets.Images.Animals.Penguin:UIColor(red: 131/255, green: 144/255, blue: 166/255, alpha: 1),
        Assets.Images.Animals.Pig:UIColor(red: 230/255, green: 229/255, blue: 242/255, alpha: 1),
        Assets.Images.Animals.Rabbit:UIColor(red: 155/255, green: 163/255, blue: 216/255, alpha: 1),
        Assets.Images.Animals.Rooster:UIColor(red: 241/255, green: 179/255, blue: 131/255, alpha: 1),
        Assets.Images.Animals.Sheep:UIColor(red: 249/255, green: 221/255, blue: 191/255, alpha: 1),
        Assets.Images.Animals.Zebra:UIColor(red: 169/255, green: 255/255, blue: 190/255, alpha: 1)
    ]
    fileprivate var lastCard:CardView?
    fileprivate var numberOfCards:Int{
        if let difficultySetting = difficulty{
            switch (difficultySetting) {
            case UserSettings.Difficulty.easy: return 12
            case UserSettings.Difficulty.medium: return 30
            case UserSettings.Difficulty.hard: return 42
            }
        }
        
        return images.count*2
    }
    fileprivate var numberOfRows:Int{ return Int((numberOfCards)/cardsPerRow) }
    fileprivate var spacer:CGFloat = 5.0
    fileprivate var timers = [Timer]()
    
    
    // MARK: View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        difficulty = UserSettings.sharedInstance.difficulty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if difficulty != UserSettings.sharedInstance.difficulty{
            difficulty = UserSettings.sharedInstance.difficulty
        }
        
        //performSegueWithIdentifier(Constants.Segues.GameOver, sender: self) // for testing
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: Public Methods
    func cardTapped(_ card: CardView) {
        func foundMatch(){
            audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Match)
            currentCard!.hide()
            lastCard!.hide()
            
            view.bringSubviewToFront(currentCard!)
            view.bringSubviewToFront(lastCard!)
            
            
            cards.remove(at: cards.firstIndex(of: currentCard!)!)
            cards.remove(at: cards.firstIndex(of: lastCard!)!)

            if isGameOver() {
                performSegue(withIdentifier: Constants.Segues.GameOver, sender: self)
            }
        }
        
        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Click)
        
        if lastCard == nil {
            lastCard = card
        }
        else {
            currentCard = card
            if currentCard!.value == lastCard!.value {
                foundMatch()
            }
            else{
                addTimer(Timer.scheduledTimer(timeInterval: 1.25, target: self, selector: Constants.Selectors.FlipTwoCards, userInfo: [currentCard!, lastCard!], repeats: false))
            }
            currentCard = nil
            lastCard = nil
        }
        
        card.visible = true
    }
    
    @objc func flipCard(_ timer:Timer?){
        if let card = timer?.userInfo as? CardView{
            card.visible = false
            removeTimer(timer)
        }
    }
    
    @objc func flipTwoCards(_ timer:Timer?){
        
        if let cards = timer?.userInfo as? [CardView]{
            if cards.count == 2 {
                cards[0].visible = false
                addTimer(Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: Constants.Selectors.FlipCard, userInfo: cards[1], repeats: false))
            }
        }
        
        removeTimer(timer)
    }
    
    // MARK: Private Methods
    fileprivate func addTimer(_ timer:Timer){
        if timers.firstIndex(of: timer) < 0 {
            timers.append(timer)
        }
    }
    
    fileprivate func animateCards(){
        for i in 0..<cards.count{
            addTimer(Timer.scheduledTimer(timeInterval: Double(i) * 0.015, target: cards[i], selector: Constants.Selectors.Show, userInfo: nil, repeats: false))
        }
    }

    fileprivate func createCards(){
        cards = []
        
        var cardImages = Array(Array(images.keys).shuffle()[0..<(numberOfCards/2)])
        cardImages += cardImages
        
        let yOffSet = view.bounds.height/2 - (CGFloat(numberOfRows) * (cardHeight+spacer))/2
        var count = 0
        while cardImages.count > 0 {
            
            let row = Int(floor(CGFloat(count/cardsPerRow)))
            let column = Int(count % cardsPerRow)
            let image = cardImages.remove(at: Int(arc4random_uniform(UInt32(cardImages.count))))
            let card = CardView(frame: CGRect(origin: CGPoint(x: CGFloat(column) * (cardWidth + spacer) + spacer, y: CGFloat(row) * (cardHeight + spacer) + CGFloat(yOffSet)), size: CGSize(width: cardWidth, height: cardHeight)), back: Assets.Images.Card, front: image, color:images[image]!)
            card.delegate = self
            
            
            view.addSubview(card)
            cards += [card]
            count += 1
        }
    }
    
    fileprivate func isGameOver() ->Bool {
        return cards.count == 0
    }

    fileprivate func removeAllTimers(){
        for timer in timers{
            removeTimer(timer)
        }
    }

    fileprivate func removeTimer(_ timer:Timer?){
        timer?.invalidate()
        if let index = timers.firstIndex(of: timer!){
            timers.remove(at: index)
        }
    }
    
    fileprivate func reset(){
        lastCard = nil
        currentCard = nil
        _ = view.subviews.map(){
            if let view = $0 as? CardView{
                view.removeFromSuperview()
            }
        }
        
        createCards()
        animateCards()
        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Start)
    }
}


extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        guard count > 2 else { return }

        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}


