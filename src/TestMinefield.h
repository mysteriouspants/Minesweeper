//
//  TestMinefield.h
//  mines
//
//  Created by Chris Miller on 6/30/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "Minefield.h"

@interface TestMinefield : SenTestCase {
    s_minefield * mines;  // "Minefield!  We're in a minefield!" -- Homeworld: Cataclysm
}

- (void)setUp;
- (void)tearDown;

- (void)testAdjacentMines0; // was giving me trouble

@end
