//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray*(^LTTableViewDataSourceFetchBlock)(NSUInteger pageNumber, NSUInteger pageSize);
typedef void(^LTTableViewDataSourceCellConfigurationBlock)(id modelObject, UITableViewCell* cell);

typedef enum {
    LTTableViewDataSourceStatusUnused = -1,
    LTTableViewDataSourceStatusIdle = 0,
    LTTableViewDataSourceStatusLoading,
    LTTableViewDataSourceStatusLoadingMore,
    LTTableViewDataSourceStatusOK,
    LTTableViewDataSourceStatusError,
    LTTableViewDataSourceStatusMAX
} LTTableViewDataSourceStatus;

typedef enum {
    LTTableViewDataSourceMoreEntriesAvailableUnknown = 0,
    LTTableViewDataSourceMoreEntriesAvailableNo,
    LTTableViewDataSourceMoreEntriesAvailableYes,
} LTTableViewDataSourceMoreEntriesAvailable;

@class LTTableViewDataSource;

@protocol LTTableViewCell <NSObject>
@required
-(void)configureForModelObject:(id)modelObject;
@optional
-(void)configureForMoreEntriesAvailableWithHint:(NSInteger)numberOfEntriesHint;
@end

@protocol LTTableViewDataSourceDelegate <NSObject, UITableViewDelegate>

@required
-(void)dataSourceDidLoadNextPage:(LTTableViewDataSource*)dataSource;

@optional
-(void)dataSource:(LTTableViewDataSource*)dataSource willPresentMoreCell:(UITableViewCell*)cell;
-(void)dataSourceWillLoadNextPage:(LTTableViewDataSource*)dataSource;

-(void)dataSource:(LTTableViewDataSource*)dataSource willAddObjectAtIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(LTTableViewDataSource*)dataSource didAddObjectAtIndexPath:(NSIndexPath*)indexPath;

-(BOOL)dataSource:(LTTableViewDataSource*)dataSource canDeleteObjectAtIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(LTTableViewDataSource*)dataSource willDeleteObjectAtIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(LTTableViewDataSource*)dataSource didDeleteObjectAtIndexPath:(NSIndexPath*)indexPath;

-(BOOL)dataSource:(LTTableViewDataSource*)dataSource canMoveObjectAtIndexPath:(NSIndexPath*)indexPath;
-(void)dataSource:(LTTableViewDataSource*)dataSource willMoveObjectAtIndexPath:(NSIndexPath*)indexPath to:(NSIndexPath*)newIndexPath;
-(void)dataSource:(LTTableViewDataSource*)dataSource didMoveObjectAtIndexPath:(NSIndexPath*)indexPath to:(NSIndexPath*)newIndexPath;

// support for alphabetically sectioned data sources
-(NSString*)dataSourceKeyForAlphabeticalSections:(LTTableViewDataSource*)dataSource;

@end

@protocol LTTableViewDataSourceStatusDelegate <LTTableViewDataSourceDelegate>
@optional
-(UIView*)tableView:(UITableView *)tableView viewForStatus:(LTTableViewDataSourceStatus)status;
@end

@interface LTTableViewDataSource : NSObject <UITableViewDataSource>

@property(weak,nonatomic) id<LTTableViewDataSourceDelegate> delegate;
@property(weak,nonatomic) UITableView* tableView;
@property(assign,nonatomic) NSInteger pageSize;
@property(assign,nonatomic) LTTableViewDataSourceStatus status;
@property(strong,nonatomic) NSMutableArray* entries;
@property(assign,nonatomic) NSUInteger visiblePages;
@property(strong,nonatomic) NSString* headerTitle;
@property(strong,nonatomic) NSString* footerTitle;
@property(assign,nonatomic) BOOL hideHeaderTitleWhenEmpty;
@property(assign,nonatomic) BOOL hideFooterTitleWhenEmpty;
@property(assign,nonatomic) CGFloat staticCellHeight;
@property(assign,getter = isEditable,nonatomic) BOOL editable;
@property(assign,getter = isMovable,nonatomic) BOOL movable;
@property(assign,nonatomic) NSUInteger section;

@property(assign,nonatomic) LTTableViewDataSourceMoreEntriesAvailable moreEntriesAvailable;
@property(strong,nonatomic) NSString* moreEntriesCellReuseIdentifier;

// support for expansion
@property(assign,nonatomic) BOOL expandable;
@property(assign,getter = isExpanded,nonatomic) BOOL expanded;
@property(assign,nonatomic) NSUInteger maximumEntriesWhenNotExpanded;

-(id)initWithDelegate:(id<LTTableViewDataSourceDelegate>)adelegate;

//
// Subclass API
//

// MANDATORY: override to fetch results, don't forget to adjust moreEntriesAvailable if necessary
-(NSArray*)fetchResultsForPage:(NSUInteger)nPage count:(NSUInteger)nCount;

// OPTIONAL: override, if you have to commit edit operations with a server or something like that
-(void)commitDeleteModelObject:(id)modelObject atIndexPath:(NSIndexPath*)indexPath;
-(void)commitMoveModelObject:(id)modelObject atIndexPath:(NSIndexPath*)sourceIndexPath to:(NSIndexPath*)destinationIndexPath;

-(UITableViewCell*)tableView:(UITableView*)tableView cellForModelObject:(id)modelObject reuseIdentifier:(NSString*)reuseIdentifier;

//
// Public API
//

-(void)attachAsDataSourceForTableView:(UITableView*)tableView;
-(id)modelObjectForRowAtIndexPath:(NSIndexPath*)indexPath;
-(BOOL)isEmpty;
-(void)loadNextPage;
-(void)removeAllPages;
-(void)setEditMode:(BOOL)editing;
-(void)deleteModelObjectAtIndexPath:(NSIndexPath*)indexPath;
-(void)insertModelObject:(id)modelObject atIndexPath:(NSIndexPath*)indexPath;
-(NSIndexPath*)indexPathForModelObject:(id)object;
-(void)saveDataIfNecessary;
-(NSUInteger)numberOfEntries;
-(void)registerCellConfigurationHookForModelClass:(Class)klass usingBlock:(LTTableViewDataSourceCellConfigurationBlock)block;
-(void)registerCellReuseIdentifierOverrideForModelClass:(Class)klass usingReuseIdentifier:(NSString*)reuseIdentifier;
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface LTSimpleTableViewDataSource : LTTableViewDataSource

+(id)simpleTableViewDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)adelegate usingFetchBlock:(LTTableViewDataSourceFetchBlock)ablock;
+(id)simpleTableViewDataSourceWithDelegate:(id<LTTableViewDataSourceDelegate>)adelegate entries:(NSArray*)entries;

@end
