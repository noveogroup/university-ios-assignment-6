#import "DatabaseManager.h"
#import <FMDB.h>
#import "Record.h"

@interface DatabaseManager ()
@property (strong, nonatomic) FMDatabase *db;
@property (copy, nonatomic) NSString *usersTableName;

- (BOOL)existUsersTable;

@end


@implementation DatabaseManager


+ (instancetype)sharedManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (BOOL)existUsersTable
{
    NSString *createUserTable = [NSString stringWithFormat:@"create table %@ (id integer primary key autoincrement, name text, password text);", self.usersTableName];    
    return [self.db executeStatements:createUserTable];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        NSString *path = [docDir stringByAppendingPathComponent:@"db.sqlite"];
        
        self.db = [[FMDatabase alloc] initWithPath:path];
        self.usersTableName = @"Users";

        
    }
    return self;
}

- (void)initializeDatabase
{
    [self.db open];
    
    NSString *userTable = @"create table Users (id integer primary key autoincrement, name text, password text);";
//    NSString *preferencesTable = @"CREATE TABLE Preferences (id integer primary key autoincrement, PasswordLength integer, IncludeLowercaseCharacters integer, IncludeUppercaseCharacters integer, IncludeNumbers integer, IncludeSymbols integer);";
    
    if ([self existUsersTable]) {
        [self.db executeUpdate:userTable];
    }
    

    
    
    
    
    
    
}

- (void)addRecord:(NSDictionary *)record
{
    NSString *serviceName = record[kServiceName];
    NSString *password = record[kPassword];
    
    NSString *request = [NSString stringWithFormat:@"insert into %@ (name, password) values ('%@', '%@');", self.usersTableName, serviceName, password];
    
    [self.db executeUpdate:request];
    
}

- (void)deleteRecord:(NSDictionary *)record
{
    NSString *serviceName = record[kServiceName];
    
    NSString *request = [NSString stringWithFormat:@"delete from %@ where name = '%@';", self.usersTableName, serviceName];
    
    [self.db executeUpdate:request];
    
}

- (void)updateRecord:(NSDictionary *)record fromNewRecord:(NSDictionary *)newRecord
{
    
    NSString *serviceName = record[kServiceName];
    NSString *newPassword = newRecord[kPassword];
    
    NSString *request = [NSString stringWithFormat:@"update %@ set password = '%@' where name = '%@';", self.usersTableName, newPassword, serviceName];
    
    [self.db executeUpdate:request];
}

- (NSArray *)getRecords
{

    FMResultSet *rs = [self.db executeQuery:@"SELECT name, password FROM Users"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    while ([rs next]) {
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        NSDictionary *responseDict = [[NSDictionary alloc] init];

        responseDict = [rs resultDictionary];
        
        [tempDict setValue:responseDict[@"name"] forKey:@"kServiceName"];
        [tempDict setValue:responseDict[@"password"] forKey:@"kPassword"];
        [tempArray addObject:tempDict];
    }
    
    return tempArray;
}

@end
