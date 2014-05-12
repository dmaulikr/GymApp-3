//
//  Exercise.h
//  GymApp
//
//  Created by mdreid 1 on 5/12/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * exercise_name;
@property (nonatomic, retain) NSNumber * num_reps;
@property (nonatomic, retain) NSNumber * num_sets;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) Workout *workout;

@end
