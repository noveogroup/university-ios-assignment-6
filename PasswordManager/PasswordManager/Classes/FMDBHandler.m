#import "FMDBHandler.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Record.h"

@interface FMDBHandler()
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation FMDBHandler

@synthesize dbQueue = dbQueue_;

-(instancetype) initDBWithUrl:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        dbQueue_ = [FMDatabaseQueue databaseQueueWithPath:[url path]];
        
        [dbQueue_ inDatabase:^(FMDatabase *db){
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS PasswordTable2("
                                "ServiceName TEXT,"
                                "Password TEXT)"];
        }];
    }
    
    return self;
}

-(void) savePasswordArray:(NSArray *)records
{
    [dbQueue_ inDatabase:^(FMDatabase *db){
        
        [db executeUpdate:@"DELETE FROM PasswordTable2"];
        
        for (NSDictionary *record in records){
            [db executeUpdate:@"INSERT INTO PasswordTable2 (ServiceName, Password)"
                                "VALUES (?,?)", record[kServiceName], record[kPassword]];
        }
        
    }];
}

-(NSMutableArray*) loadPasswordArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    [dbQueue_ inDatabase:^(FMDatabase *db){
        FMResultSet *result = [db executeQuery:@"SELECT * FROM PasswordTable2"];
        while([result next]){
            NSDictionary *const record = @{kServiceName: [result stringForColumn:@"ServiceName"],
                                           kPassword: [result stringForColumn:@"Password"]};
            [resultArray addObject:record];
            
        }
    }];
    return resultArray;
}

@end