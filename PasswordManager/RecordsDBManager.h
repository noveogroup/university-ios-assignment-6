
#import <Foundation/Foundation.h>

@interface RecordsDBManager : NSObject

/**
 *  Performs no initialization; please use @c -initWithURL: instead.
 */
- (id)init;

/**
 *  Initializes a newly created instance with the specifed URL.
 */
- (instancetype)initWithPath:(NSString *)path;

/**
 *  Registers the specified record.
 */
- (void)registerRecord:(NSDictionary *)record;

- (void)removeRecord:(NSDictionary *)record;


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