//
//  ViewController.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/18/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation

class MatchGameViewController: UIViewController, CardViewDelegate {
    
    struct Constants{
        struct Segues{
            static let GameOver = "Game Over"
        }
        struct Selectors{
            static let FlipCard:Selector = "flipCard:"
            static let FlipTwoCards:Selector = "flipTwoCards:"
            static let Show:Selector = "show"
        }
    }
    
    private var images = [
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
    
    // MARK: Private Members
    private var audioPlayer:AVAudioPlayer?
    private var cards = [CardView]()
    private var cardHeight: CGFloat { return self.cardWidth }
    private var cardsPerRow:Int {
        switch(numberOfCards){
        case (0...12):
            return 4
        case (13...30):
            return 5
        default:
            return 6
        }
    }
    private var cardWidth: CGFloat { return (view.bounds.width - (spacer * CGFloat(cardsPerRow+1))) / CGFloat(cardsPerRow) }
    private var currentCard:CardView?
    private var difficulty:UserSettings.Difficulty?{
        didSet{
            reset()
        }
    }
    private var numberOfCards:Int{
        if let difficultySetting = difficulty{
            switch (difficultySetting) {
            case UserSettings.Difficulty.Easy: return 12
            case UserSettings.Difficulty.Medium: return 30
            case UserSettings.Difficulty.Hard: return 42
            }
        }
        
        return images.count*2
    }
    private var numberOfRows:Int{ return Int((numberOfCards)/cardsPerRow) }
    private var lastCard:CardView?
    private var spacer:CGFloat = 5.0
    private var timers = [NSTimer]()
    
    // MARK: View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        difficulty = UserSettings.sharedInstance.difficulty
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if difficulty != UserSettings.sharedInstance.difficulty{
            difficulty = UserSettings.sharedInstance.difficulty
        }
        
        performSegueWithIdentifier(Constants.Segues.GameOver, sender: self) // for testing
    }


    override func viewWillDisappear(animated: Bool) {
        removeAllTimers()
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: Public Methods
    
    func cardTapped(card: CardView) {
        func foundMatch(){
            audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Match)
            currentCard?.hide()
            lastCard?.hide()
            
            cards.removeAtIndex(cards.indexOf(currentCard!)!)
            cards.removeAtIndex(cards.indexOf(lastCard!)!)

            if isGameOver() {
                performSegueWithIdentifier(Constants.Segues.GameOver, sender: self)
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
                addTimer(NSTimer.scheduledTimerWithTimeInterval(1.25, target: self, selector: Constants.Selectors.FlipTwoCards, userInfo: [currentCard!, lastCard!], repeats: false))
            }
            currentCard = nil
            lastCard = nil
        }
        
        card.visible = true
    }
    
    func flipCard(timer:NSTimer?){
        if let card = timer?.userInfo as? CardView{
            card.visible = false
            removeTimer(timer)
        }
    }
    
    func flipTwoCards(timer:NSTimer?){
        
        if let cards = timer?.userInfo as? [CardView]{
            if cards.count == 2 {
                cards[0].visible = false
                addTimer(NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Constants.Selectors.FlipCard, userInfo: cards[1], repeats: false))
            }
        }
        
        removeTimer(timer)
    }
    
    // MARK: Private Methods
    private func addTimer(timer:NSTimer){
        if timers.indexOf(timer) < 0 {
            timers.append(timer)
        }
    }
    
    private func animateCards(){
        for i in 0..<cards.count{
            addTimer(NSTimer.scheduledTimerWithTimeInterval(Double(i) * 0.015, target: cards[i], selector: Constants.Selectors.Show, userInfo: nil, repeats: false))
        }
    }

    private func createCards(){
        cards = []
        
        var cardImages = Array(Array(images.keys).shuffle()[0..<(numberOfCards/2)])
        cardImages += cardImages
        
        let yOffSet = view.bounds.height/2 - (CGFloat(numberOfRows) * (cardHeight+spacer))/2
        var count = 0
        while cardImages.count > 0 {
            
            let row = Int(floor(CGFloat(count/cardsPerRow)))
            let column = Int(count % cardsPerRow)
            let image = cardImages.removeAtIndex(Int(arc4random_uniform(UInt32(cardImages.count))))
            let card = CardView(frame: CGRect(origin: CGPoint(x: CGFloat(column) * (cardWidth + spacer) + spacer, y: CGFloat(row) * (cardHeight + spacer) + CGFloat(yOffSet)), size: CGSize(width: cardWidth, height: cardHeight)), back: Assets.Images.Card, front: image, color:images[image]!)
            card.delegate = self
            
            
            view.addSubview(card)
            cards += [card]
            count++
        }
    }
    
    private func isGameOver() ->Bool {
        return cards.count == 0
    }

    private func removeTimer(timer:NSTimer?){
        timer?.invalidate()
        if let index = timers.indexOf(timer!){
            timers.removeAtIndex(index)
        }
    }
    
    private func removeAllTimers(){
        for timer in timers{
            removeTimer(timer)
        }
    }
    
    private func reset(){
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


extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}


