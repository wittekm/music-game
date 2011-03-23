/*
 *  Utility.h
 *  Collective
 *
 *  Created by Max Wittek on 2/15/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef UTILITY_H
#define UTILITY_H
 

template <typename T>
struct Pair {
	T a, b;
};

template <typename T>
struct Triplet {
	T a, b, c;
};

typedef Triplet<int> RGBColor;

 
#endif