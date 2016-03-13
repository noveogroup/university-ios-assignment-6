
@protocol RecordsManagerProtocol <NSObject>

/**
 *  Registers the specified record.
 */
- (void)registerRecord:(NSDictionary *)record;

- (void)updateRecord:(NSDictionary *)record;

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
