//
//  Workout.h
//  GymApp
//
//  Created by mdreid 1 on 5/11/14.
//  Copyright (c) 2014 mdreid 1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSDate * workout_date;
@property (nonatomic, retain) NSDate * workout_lastdate;
@property (nonatomic, retain) NSString * workout_name;
@property (nonatomic, retain) NSSet *exercises;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addExercisesObject:(Exercise *)value;
- (void)removeExercisesObject:(Exercise *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

@end
