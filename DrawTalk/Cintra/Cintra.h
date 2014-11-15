//
//  Cintra.h
//  Cintra
//
//  Created by Jacek Suliga on 11/7/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "CINLogging.h"


// Enable when using core data.
#define CINTRA_USE_CORE_DATA  1




#ifdef CINTRA_USE_CORE_DATA

// When with core data, ensure managed objects
#define CINPersistenceModelBaseClass NSManagedObject
#define CINPersistenceObjectID       NSManagedObjectID

#define CINTRA_RELATIONSHIP_ACCESSORS(cin_attribute, cin_Attribute, lcn_class)

#else

// This is an example of redefining the constants and relationship accessors
// for projects that are switching from using Core Data into some other persistence model.

#define CINPersistenceModelBaseClass NSObject
#define CINPersistenceObjectID       NSObject

// We need this to comply with the core-data generated accessors for relationships
#define CINTRA_RELATIONSHIP_ACCESSORS(cin_attribute, cin_Attribute, lcn_class) \
- (void)add##cin_Attribute##Object:(lcn_class *)value { \
if (!self.cin_attribute) self.cin_attribute = [NSSet set]; \
self.cin_attribute = [self.cin_attribute setByAddingObject:value]; \
} \
- (void)remove##cin_Attribute##Object:(lcn_class *)value { \
NSMutableSet * s = [NSMutableSet setWithSet:self.cin_attribute]; \
[s removeObject:value]; \
self.cin_attribute = s; \
} \
- (void)add##cin_Attribute:(NSSet *)values { \
if (!self.cin_attribute) self.cin_attribute = [NSSet set]; \
self.cin_attribute = [self.cin_attribute setByAddingObjectsFromSet:values]; \
} \
- (void)remove##cin_Attribute:(NSSet *)values { \
NSMutableSet * s = [NSMutableSet setWithSet:self.cin_attribute]; \
[s minusSet:values]; \
self.cin_attribute = s; \
}

#endif
