#import "NSDirectoryEnumerator+ProjectBrowser.h"
#import "NSURL+CDEAdditions.h"

@implementation NSURL (ProjectBrowser)

- (nullable NSManagedObjectModel *)transformedManagedObjectModel {
  BOOL isModel = [self isCompiledManagedObjectModelFile_cde];
  if(isModel == NO) {
    return nil;
  }
  
  // try-catch because it is very well possible that a file seems to be a managed object model
  // but it isn't or something else goes wrong when we initialize an NSManagedObjectModel with
  // (unknown) contents of a file.
  NSManagedObjectModel *transformedModel;
  @try {
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self];
    if(model == nil) {
      return nil;
    }
    transformedModel = model.transformedManagedObjectModel_cde;
    if(transformedModel == nil) {
      return nil;
    }
  }
  @catch (NSException *exception) {
    
  }
  @finally {
    
  }
  return transformedModel;
}

- (nullable NSDictionary<NSString *, id> *)persistentStoreMetadata {
  BOOL isData = [self isPublicDataFile_cde];
  if(isData == NO) {
    return nil;
  }
  
  if([self isSQLiteURL_cde] == NO) {
    return nil;
  }
  if([self isSQLiteStoreURL_cde] == NO) {
    return nil;
  }
  NSDictionary *metadata;
  @try {
    NSError *error;
    // +metadataForPersistentStoreOfType:URL:error: fails if we have a SQLite file but it is not a Core Data SQLite file...
    metadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:self options:nil error:&error];
    
    if(metadata == nil) {
      return nil;
    }
  }
  @catch (NSException *exception) {
    
  }
  @finally {
    
  }
  return metadata;
}

@end

@implementation NSDirectoryEnumerator (ProjectBrowser)

- (void)getModeldata:(NSDictionary<NSString*, NSManagedObjectModel*> **)outModelByModelPath {
    NSMutableDictionary *modelByModelPath = [NSMutableDictionary new];

    for (NSURL *URL in self) {
        // Is URL a managed object model file?
        NSManagedObjectModel *model = [URL transformedManagedObjectModel];
        if (model != nil) { // YES
            modelByModelPath[URL.path] = model;
            break;
        }
    }

    if (outModelByModelPath != NULL) {
        *outModelByModelPath = modelByModelPath;
    }
}

- (void)getMetadata:(NSDictionary<NSString*, NSDictionary*> **)outMetadataByStorePath {
    NSMutableDictionary *metadataByStorePath = [NSMutableDictionary new];

    for(NSURL *URL in self) {
        if ([URL isPublicDataFile_cde] == NO) {
            continue;
        }

        if ([URL isSQLiteURL_cde] == NO) {
            continue;
        }

        NSDictionary *metadata = [URL persistentStoreMetadata];
        if(metadata == nil) {
            continue;
        }

        metadataByStorePath[URL.path] = metadata;
        break;
    }

    if (outMetadataByStorePath != NULL) {
        *outMetadataByStorePath = metadataByStorePath;
    }
}

- (void)getMetadataByStorePath:(NSDictionary<NSString*, NSDictionary*> **)outMetadataByStorePath modelByModelPath:(NSDictionary<NSString*, NSManagedObjectModel*> **)outModelByModelPath {
  NSMutableDictionary *metadataByStorePath = [NSMutableDictionary new];
  NSMutableDictionary *modelByModelPath = [NSMutableDictionary new];

  for(NSURL *URL in self) {
    // Is URL a managed object model file?
    NSManagedObjectModel *model = [URL transformedManagedObjectModel];
    if(model != nil) { // YES
      modelByModelPath[URL.path] = model;
      continue;
    }

    BOOL isData = [URL isPublicDataFile_cde];
    if(isData == NO) {
      continue;
    }

    if([URL isSQLiteURL_cde] == NO) {
      continue;
    }

    NSDictionary *metadata = [URL persistentStoreMetadata];
    if(metadata == nil) {
      continue;
    }
    metadataByStorePath[URL.path] = metadata;
  }

  if(outMetadataByStorePath != NULL) {
    *outMetadataByStorePath = metadataByStorePath;
  }
  if(outModelByModelPath != NULL) {
    *outModelByModelPath = modelByModelPath;
  }
}

@end
