
#import "RecordsDBManager.h"
#import "Record.h"
#import "FMDB.h"

@interface RecordsDBManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) FMDatabase* db;

@end

@implementation RecordsDBManager

@synthesize path = path_;
@synthesize mutableRecords = mutableRecords_;
@synthesize db = db_;


- (id)init
{
    NSLog(@"Please use -initWithURL: instead.");
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (instancetype)initWithPath:(NSString *)path
{
    if ((self = [super init])) {
        path_ = path;
    }
    
    return self;
}

- (void) createDB
{
    NSString *dbPath = @"/records.db";
    
    NSString *createTableQuery = [NSString stringWithFormat:@"CREATE TABLE records (%@ TEXT DEFAULT NULL, %@ TEXT DEFAULT NULL)", kServiceName, kPassword];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    [database executeUpdate:createTableQuery];
    
    [database close];
}

#pragma mark - Management of records

- (void)registerRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords addObject:record];
        
        NSString *DBMessage = [NSString stringWithFormat:@"INSERT INTO records (%@, %@) values (?, ?)", kServiceName, kPassword];
        
        [self.db open];

        
        BOOL success = [db_ executeUpdate:DBMessage, record[kServiceName], record[kPassword]];
        
        if (!success) {
            NSLog(@"%s: insert error: %@", __FUNCTION__, [self.db lastErrorMessage]);
            
            // do whatever you need to upon error
        }
        
        [db_ close];
    
    }
}

- (void)removeRecord:(NSDictionary *)record
{
    if ([record count] > 0) {

        [self.mutableRecords removeObject:record];
        
        [self.db open];
        
        NSString *DBMessage = [NSString stringWithFormat:@"DELETE FROM records WHERE %@ = ?", kServiceName];
        [db_ executeUpdate:DBMessage, record[kServiceName]];
    
        [db_ close];
    }
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        mutableRecords_ = [NSMutableArray array];
        
        [self.db open];
        
        FMResultSet *rs = [db_ executeQuery:@"SELECT * FROM records"];
        
        if (!rs) {
            NSLog(@"%s: select error: %@", __FUNCTION__, [db_ lastErrorMessage]);
            
            // do whatever you want upon error
            
            return nil;
        }
        
        while ([rs next]) {
            NSDictionary* record = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [rs stringForColumn:kServiceName], kServiceName,
                                    [rs stringForColumn:kPassword], kPassword, nil];
            [mutableRecords_ addObject:record];
        }
        
        [rs close];
        [db_ close];
        
    }
    
    return mutableRecords_;
}

- (NSArray *)records
{
    return [self.mutableRecords copy];
}

- (FMDatabase *)db
{
    if (!db_) {
        db_ = [FMDatabase databaseWithPath:path_];
        
        NSString *createTableQuery = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS records (%@ TEXT DEFAULT NULL, %@ TEXT DEFAULT NULL)", kServiceName, kPassword];
        
        [db_ open];
        BOOL success = [db_ executeUpdate:createTableQuery];
        [db_ close];

        if (!success) {
            NSLog(@"%s: create table error: %@", __FUNCTION__, [db_ lastErrorMessage]);
            
            // do whatever you want upon error
            return nil;
        } else {
            NSLog(@"db was opened");
        }
    }
    return db_;
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{

    return YES;
}


@end
