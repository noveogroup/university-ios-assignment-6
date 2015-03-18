#import "DBHelper.h"
#import "Record.h"
#import "FMDB.h"


static NSString *const recordsTableName = @"records";
static NSString *const serviceNameColumn = @"service_name";
static NSString *const passwordColumn = @"password";


@implementation DBHelper

+ (BOOL)insertRecord:(NSDictionary *)record intoDB:(FMDatabase *)db {
    NSLog(@"Insert record: {%@: %@}", record[kServiceName], record[kPassword]);
    NSString *queryString = [NSString stringWithFormat:
        @"INSERT INTO %@ (%@, %@) VALUES (?, ?)",
            recordsTableName, serviceNameColumn, passwordColumn];
    return [db executeUpdate:queryString, record[kServiceName], record[kPassword]];
}

+ (BOOL)updateRecord:(NSDictionary *)record intoDB:(FMDatabase *)db {
    NSLog(@"Update record: {%@: %@}", record[kServiceName], record[kPassword]);
    NSString *queryString = [NSString stringWithFormat:
        @"UPDATE %@ SET %@ = ? WHERE %@ = ?", recordsTableName, passwordColumn, serviceNameColumn];
    return [db executeUpdate:queryString, record[kPassword], record[kServiceName]];
}

+ (BOOL)deleteRecord:(NSDictionary *)record intoDB:(FMDatabase *)db {
    NSLog(@"Delete record: {%@: %@}", record[kServiceName], record[kPassword]);
    NSString *queryString = [NSString stringWithFormat:
        @"DELETE FROM %@ WHERE %@ = ?", recordsTableName, serviceNameColumn];
    return [db executeUpdate:queryString, record[kServiceName]];
}

+ (BOOL)createRecordsTableInDatabase:(FMDatabase *)database {
    NSString *createTableQuery = [NSString stringWithFormat:
        @"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT)",
            recordsTableName, serviceNameColumn, passwordColumn];
    [database open];
    BOOL tableCreationResult = [database executeUpdate:createTableQuery];
    if (tableCreationResult) {
        NSLog(@"Table 'records' has been created.");
    }
    [database close];
    return tableCreationResult;
}

+ (NSMutableArray *)allRecordsFromDbWithPath:(NSString *)dbPath {
    NSMutableArray *records = [[NSMutableArray alloc] init];
    FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    
    [queue inDatabase:^(FMDatabase *db) {
        NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@", recordsTableName];
        FMResultSet *results = [db executeQuery:queryString];
        
        while ([results next]) {
            NSString *serviceName = [results stringForColumn:serviceNameColumn];
            NSString *password = [results stringForColumn:passwordColumn];
            [records addObject:@{kServiceName: serviceName, kPassword: password}];
        }
    }];
    
    return records;
}

@end
