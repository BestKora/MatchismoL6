//
//  CardGameViewController.m
//  Assignment-2-iOS7
//
//  Created by Tatiana Kornilova on 7/12/14.
//  Copyright (c) 2014 Tatiana Kornilova. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfMatchesSegment;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        _game.numberOfMatches =[self numberOfMatches];

    }
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)numberOfMatches
{
    return self.numberOfMatchesSegment.selectedSegmentIndex+2;
}

- (IBAction)dealPress:(id)sender {
    self.numberOfMatchesSegment.enabled =YES;
    self.game = nil;
    [self updateUI];
}

- (IBAction)changeNumberOfMatches:(UISegmentedControl *)sender {
    self.game = nil;
    [self updateUI];
}

- (IBAction)touchCardButton:(id)sender
{
    self.numberOfMatchesSegment.enabled =NO;
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.matched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
        [self updateFlipResult];
}

-(void)updateFlipResult
{
    NSString *text=@" ";
    if ([self.game.matchedCards  count]>0)
    {
        text = [text stringByAppendingString:[self.game.matchedCards componentsJoinedByString:@" "]];
        if ([self.game.matchedCards count] == [self numberOfMatches])
        {
            if (self.game.lastFlipPoints<0) {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"✘ %ld penalty",(long)self.game.lastFlipPoints]];
            } else {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"✔ +%ld bonus",(long)self.game.lastFlipPoints]];
            }
        } else text =[self textForSingleCard];
    } else text = @"Play game!";
    self.resultsLabel.text = text;
}

- (NSString *)textForSingleCard
{
    Card *card = [self.game.matchedCards lastObject];
    return [NSString stringWithFormat:@" %@ flipped %@",card,(card.isChosen) ? @"up!" : @"back!"];
}



- (NSString *)titleForCard:(Card *)card
{
    return card.chosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

@end
