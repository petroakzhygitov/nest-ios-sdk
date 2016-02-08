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
@property(nonatomic) XLFormRowDescriptor *nameRow;
@property(nonatomic) XLFormRowDescriptor *nameLongRow;
@property(nonatomic) XLFormRowDescriptor *isOnlineRow;
@property(nonatomic) XLFormRowDescriptor *whereIdRow;

#pragma mark Methods

- (void)addTitle;

- (void)addDeviceObservers;

- (void)addForm;

- (void)addRows;

- (void)updateTableViewHeader;

- (void)updateDeviceData;

- (void)updateTableView;

- (void)updateTableViewData;

- (XLFormRowDescriptor *)addReadOnlyTextRowWithText:(NSString *)text;

- (XLFormRowDescriptor *)addReadWriteSwitchRowWithTitle:(NSString *)title boolValue:(BOOL)value;

- (void)addReadWriteRow:(XLFormRowDescriptor *)row;

@end