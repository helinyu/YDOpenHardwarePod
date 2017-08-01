//
//  MSDatabaseQueue.h
//  SportsBar
//
//  Created by 张旻可 on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface MSDatabaseQueue : FMDatabaseQueue

/** Synchronously perform database operations on queue.
 
 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inAsyncDatabase:(void (^)(FMDatabase *db))block;

/** Synchronously perform database operations on queue, using transactions.
 
 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inAsyncTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using deferred transactions.
 
 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inAsyncDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;


//Minster add
- (void)inAsyncDatabase:(void (^)(FMDatabase *db))block completHandler: (void (^)())complet_handler;

/** Synchronously perform database operations on queue, using transactions.
 
 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inAsyncTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;

/** Synchronously perform database operations on queue, using deferred transactions.
 
 @param block The code to be run on the queue of `FMDatabaseQueue`
 */

- (void)inAsyncDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;

@end
