#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+ (instancetype)sharedManager;
- (void)initializeDatabase;
- (void)addRecord:(NSDictionary *)record;
- (void)deleteRecord:(NSDictionary *)record;
- (void)updateRecord:(NSDictionary *)record fromNewRecord:(NSDictionary *)newRecord;
- (NSArray *)getRecords;

@end
