#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XLForm/XLFormViewController.h>
#import <NestSDK/NestSDK.h>

@protocol NestSDKDevice;
@protocol DeviceViewModel;


@interface DeviceDetailsViewController : XLFormViewController <XLFormDescriptorDelegate>
#pragma mark Properties

@property IBOutlet UITableView *tableView;

@property(nonatomic) id <DeviceViewModel> deviceViewModel;

@property(nonatomic) NestSDKDataManager *dataManager;

@property(nonatomic, copy) void (^deviceUpdateHandlerBlock)(id <NestSDKDevice>, NSError *);

@property(nonatomic) BOOL updatingTableViewData;

@property(nonatomic) XLFormRowDescriptor *deviceIdRow;
@property(nonatomic) XLFormRowDescriptor *softwareVersionRow;
@property(nonatomic) XLFormRowDescriptor *structureIdRow;
@property(nonatomic) XLFormRowDescriptor *nameIdRow;
@property(nonatomic) XLFormRowDescriptor *nameLongIdRow;
@property(nonatomic) XLFormRowDescriptor *isOnlineIdRow;
@property(nonatomic) XLFormRowDescriptor *whereIdRow;

#pragma mark Methods

- (void)addTitle;

- (void)addDeviceObservers;

- (void)addForm;

- (void)addRows;

- (void)updateTableViewHeader;

- (void)updateDeviceViewModelData;

- (void)setDeviceViewModelData;

- (void)updateTableView;

- (void)updateTableViewData;

- (XLFormRowDescriptor *)addReadOnlyTextRowWithTitle:(NSString *)title text:(NSString *)text;

- (XLFormRowDescriptor *)addReadOnlyDateTimeRowWithTitle:(NSString *)title date:(NSDate *)date;

- (XLFormRowDescriptor *)addReadWriteTextRowWithTitle:(NSString *)title boolValue:(BOOL)value;

- (void)addReadWriteRow:(XLFormRowDescriptor *)row;

@end