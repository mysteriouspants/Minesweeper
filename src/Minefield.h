/*
 *  Minefield.h
 *  mines
 *
 *  Created by Chris Miller on 6/30/10.
 *  Copyright 2010 FSDEV. All rights reserved.
 *
 */

#include <stdlib.h>

typedef enum {
    EMPTY=  0x0000, // 0000
    CLICKED=0x0001, // 0001
    MINED=  0x0002, // 0010
    FLAGGED=0x0004, // 0100
    QMARKED=0x0008  // 1000
} tileState;

static const NSInteger mines_dx[8] = { -1, +0, +1, +1, +1, +0, -1, -1 };
static const NSInteger mines_dy[8] = { +1, +1, +1, +0, -1, -1, -1, +0 };

typedef struct {
    NSInteger x;
    NSInteger y;
    tileState **minefield;
} s_minefield;

s_minefield* MakeMinefield(NSInteger row,
                           NSInteger col);
void freeMinefield(s_minefield *minefield);
BOOL inBounds(s_minefield * mines,
              const NSInteger row,
              const NSInteger col);

NSInteger adjacentMines(s_minefield *minefield,
                        const NSInteger row,
                        const NSInteger col);
s_minefield* generateMinefield(CGFloat minesMin,
                               CGFloat minesMax);
BOOL winConditions(s_minefield *mines);
void logMinefield(s_minefield *mines);
NSInteger countMines(s_minefield *minefield);
NSInteger countFlags(s_minefield *minefield);

#define MINES_ROWS 8
#define MINES_COLS 8
#define HAS_MINE(m, row, col) ((m->minefield[row][col] & MINED) - MINED == 0)
#define HAS_FLAG(m, row, col) ((m->minefield[row][col] & FLAGGED) - FLAGGED == 0)
#define HAS_QMARK(m, row, col) ((m->minefield[row][col] & QMARKED) - QMARKED == 0)
#define HAS_CLICKED(m, row, col) ((m->minefield[row][col] & CLICKED) - CLICKED == 0)
#define IN_BOUNDS(m, row, col) ((row < 0 || row > m->x) || (col < 0 || col > m->y))
