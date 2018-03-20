#import <Foundation/Foundation.h>

@interface NSURL (ProjectBrowser)

- (nullable NSManagedObjectModel *)transformedManagedObjectModel;

@end

@interface NSDirectoryEnumerator (ProjectBrowser)

- (void)getModeldata:(NSDictionary<NSString*, NSManagedObjectModel*> **)outModelByModelPath;

- (void)getMetadata:(NSDictionary<NSString*, NSDictionary*> **)outMetadataByStorePath;

- (void)getMetadataByStorePath:(NSDictionary<NSString*, NSDictionary*> **)metadataByStorePath modelByModelPath:(NSDictionary<NSString*, NSManagedObjectModel*> **)modelByModelPath;

@end

