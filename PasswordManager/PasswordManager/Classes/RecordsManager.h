#import <Foundation/Foundation.h>

@interface RecordsManager : NSObject

/**
 *  Performs no initialization; please use @c -initWithURL: instead.
 */
- (id)init;

/**
 *  Initializes a newly created instance with the specifed URL.
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  Registers the specified record.
 */
- (void)registerRecord:(NSDictionary *)record;

/**
 *  Remove the specified record.
 */
- (void)removeRecord:(NSDictionary *)record;


//- (void)changePasswordForRecord:(NSDictionary *)record withPrevRecord:(NSDictionary *)prevRecord;

- (void)replaceRecord:(NSDictionary *)record withNewRecord:(NSDictionary *)newRecord;



/**
 *  Returns the records the receiver manages.
 */
- (NSArray *)records;

- (NSArray *)recordsDB;

/**
 *  Writes any modifications to the persistent domains to disk.
 *
 *  @return @c YES if the records were saved successfully to disk.
 */
- (BOOL)synchronize;

@end
