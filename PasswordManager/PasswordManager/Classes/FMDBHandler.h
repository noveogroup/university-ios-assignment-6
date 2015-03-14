#import <Foundation/Foundation.h>

@interface FMDBHandler : NSObject

-(instancetype) initDBWithUrl:(NSURL *) url;
-(NSMutableArray*) loadPasswordArray;
-(void) savePasswordArray:(NSArray*) records;

@end
