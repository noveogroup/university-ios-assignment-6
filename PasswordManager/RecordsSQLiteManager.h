
#import <Foundation/Foundation.h>
#import "RecordsManagerProtocol.h"

@interface RecordsSQLiteManager : NSObject <RecordsManagerProtocol>

/**
 *  Performs no initialization; please use @c -initWithURL: instead.
 */
- (id)init;

/**
 *  Initializes a newly created instance with the specifed URL.
 */
- (instancetype)initWithPath:(NSString *)path;

@end