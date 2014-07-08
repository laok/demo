//
//  Entity.h
//  UseCoreData
//
//  Created by zhaokai on 14-7-7.
//  Copyright (c) 2014年 kk. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Entity : NSManagedObject

@property (nonatomic, retain) NSNumber * task_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSNumber * done;
@end
