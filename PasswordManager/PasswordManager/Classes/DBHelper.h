#import <Foundation/Foundation.h>


@class FMDatabase;


@interface DBHelper : NSObject

/**
 *  Inserts the specified record into 'records' table of the passed database.
 *  The passed databese should be OPENED and the method doesn't close it!
 */
+ (BOOL)insertRecord:(NSDictionary *)record intoDB:(FMDatabase *)db;

/**
 *  Updates the specified record in 'records' table of the passed database
 *  The passed databese should be OPENED and the method doesn't close it!
 */
+ (BOOL)updateRecord:(NSDictionary *)record intoDB:(FMDatabase *)db;

/**
 *  Deletes the specified record from 'records' table of the passed database
 *  The passed databese should be OPENED and the method doesn't close it!
 */
+ (BOOL)deleteRecord:(NSDictionary *)record intoDB:(FMDatabase *)db;

/**
 *  Creates 'records' table if not exists
 *  The passed databese should NOT be OPENED. The method opens and closes it by self.
 */
+ (BOOL)createRecordsTableInDatabase:(FMDatabase *)database;

/**
 *  Returns all records from 'records' table of database located in the specified path
 */
+ (NSMutableArray *)allRecordsFromDbWithPath:(NSString *)dbPath;

@end
