#import <Foundation/Foundation.h>


@protocol StorageController <NSObject>

/**
 *  Registers the specified record.
 */
- (void)registerRecord:(NSDictionary *)record;

/**
 *  Deletes the specified record.
 */
- (void)deleteRecord:(NSDictionary *)record;

/**
 *  Modifies the specified record by the new record.
 */
- (void)modifyRecord:(NSDictionary *)recordToBeModified byRecord:(NSDictionary *)newRecord;

/**
 *  Returns the records the receiver manages.
 */
- (NSArray *)records;

/**
 *  Writes any modifications to the persistent domains to disk.
 *
 *  @return @c YES if the records were saved successfully to disk.
 */
- (BOOL)synchronize;

@end
