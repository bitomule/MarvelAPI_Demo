//
//  CharactersFilterViewController.swift
//  WallapopMarvel
//
//  Created by David Collado on 12/5/17.
//  Copyright © 2017 bitomule. All rights reserved.
//

import UIKit

enum Character:Int{
  case Hulk
  case Spiderman
  case IronMan
  case DeadPool
  case AntMan
  case Thor
}

extension Character{
  var id:Int{
    switch self {
    case .Hulk:
      return 1009351
    case .Spiderman:
      return 1009610
    case .IronMan:
      return 1009368
    case .DeadPool:
      return 1009268
    case .AntMan:
      return 1010802
    case .Thor:
      return 1009664
    }
  }
}

class CharactersFilterViewController: UIViewController {
  
  @IBOutlet weak var buttonsContainer: UIStackView!
  @IBOutlet var buttons: [UIButton]!
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    guard let character = Character(rawValue: sender.tag) else {return}
    optionSelected(character.id)
    dismiss(animated: true, completion: nil)
  }
  
  let transitionDelegate = CharacterFilterMenuTransitioningDelegate()
  
  let optionSelected:(Int)->()
  
  init(optionSelected:@escaping (Int)->()) {
    self.optionSelected = optionSelected
    super.init(nibName: "\(CharactersFilterViewController.self)", bundle: nil)
    self.transitioningDelegate = transitionDelegate
    self.modalPresentationStyle = .custom
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gesture = UITapGestureRecognizer()
    gesture.reactive.stateChanged.filter({$0.state == .recognized}).observeValues {[weak self] _ in
      self?.dismiss(animated: true, completion: nil)
    }
    view.addGestureRecognizer(gesture)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    for button in buttons{
      button.layer.cornerRadius = button.bounds.width * 0.5
    }
  }
  
}

//MARK: - Animación de entrada

private final class CustomPresentationAnimator: NSObject,UIViewControllerAnimatedTransitioning{
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let containerView = transitionContext.containerView
    
    let animationDuration = transitionDuration(using: transitionContext)
    
    guard let menu = toViewController as? CharactersFilterViewController else {
      transitionContext.completeTransition(true)
      return
    }
    
    menu.buttonsContainer.transform = CGAffineTransform(scaleX: 0, y: 0)
    
    containerView.addSubview(toViewController.view)
    toViewController.view.frame.size = containerView.frame.size
    
    UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
      menu.buttonsContainer.transform = CGAffineTransform.identity
    }, completion: { finished in
      transitionContext.completeTransition(finished)
    })
    
  }
  
}

//MARK: - Animación de salida

private final class CustomDismissionAnimator: NSObject, UIViewControllerAnimatedTransitioning{
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.2
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let animationDuration = transitionDuration(using: transitionContext)
    
    guard let menu = fromViewController as? CharactersFilterViewController else {
      transitionContext.completeTransition(true)
      return
    }
    
    menu.buttonsContainer.transform = CGAffineTransform.identity
    
    UIView.animate(withDuration: animationDuration, animations: {
      menu.buttonsContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }) { finished in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}

//MARK: - Delegate de transición

final class CharacterFilterMenuTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate{
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomPresentationAnimator()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomDismissionAnimator()
  }
}
