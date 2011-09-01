//
//  TestMinefield.m
//  mines
//
//  Created by Chris Miller on 6/30/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "TestMinefield.h"


@implementation TestMinefield

- (void)setUp {
    mines = MakeMinefield(8, 8);
    for(NSInteger i=0; i<8; ++i)
        for(NSInteger j=0; j<8; ++j)
            mines->minefield[i][j] = EMPTY;
}

- (void)tearDown {
    freeMinefield(mines);
}

- (void)testAdjacentMines0 {
    // this is a specific minefield that gave me grief
    /*   0 1 2 3 4 5 6 7
     * 0   M           2!
     * 1         M     M
     * 2 M         M
     * 3         M   M
     * 4
     * 5
     * 6       M     M M
     * 7   M M
     */
    mines->minefield[1][0] += MINED;
    mines->minefield[4][1] += MINED;
    mines->minefield[7][1] += MINED;
    mines->minefield[0][2] += MINED;
    mines->minefield[5][2] += MINED;
    mines->minefield[4][3] += MINED;
    mines->minefield[6][3] += MINED;
    mines->minefield[3][6] += MINED;
    mines->minefield[6][6] += MINED;
    mines->minefield[7][6] += MINED;
    mines->minefield[1][7] += MINED;
    mines->minefield[2][7] += MINED;
    NSLog(@"Mines at 0,7: %ld",adjacentMines(mines, 0, 7));
    STAssertTrue(1 == adjacentMines(mines, 0, 7), @"Corner case failed again.");
}

- (void)dealloc {
    if(mines)
        freeMinefield(mines);
    [super dealloc];
}

@end
