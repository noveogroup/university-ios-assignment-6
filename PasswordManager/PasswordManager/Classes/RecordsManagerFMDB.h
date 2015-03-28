#import <Foundation/Foundation.h>
#import "StorageController.h"


@interface RecordsManagerFMDB : NSObject <StorageController>

/**
 *  Performs no initialization; please use @c -initWithDbPath: instead.
 */
- (id)init;

/**
 *  Initializes a newly created instance with the specifed dbPath.
 */
- (instancetype)initWithDbPath:(NSString *)dbPath;

@end
