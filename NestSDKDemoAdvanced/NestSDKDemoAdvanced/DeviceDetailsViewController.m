#import <NestSDK/NestSDKDevice.h>
#import <XLForm/XLForm.h>
#import <NestSDK/NestSDKDataManager.h>
#import <NestSDK/NestSDKMacroses.h>
#import "DeviceDetailsViewController.h"
#import "DeviceViewModel.h"


@interface DeviceDetailsViewController ()

@property(nonatomic, strong) XLFormSectionDescriptor *readOnlySection;
@property(nonatomic, strong) XLFormSectionDescriptor *readWriteSection;

@end


@implementation DeviceDetailsViewController
#pragma mark Private

- (void)addDeviceIdRow {
    self.deviceIdRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.deviceIdText];
}

- (void)addSoftwareVersionRow {
    self.softwareVersionRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.softwareVersionText];
}

- (void)addStructureIdRow {
    self.structureIdRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.structureIdText];
}

- (void)addNameRow {
    self.nameRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.nameText];
}

- (void)addLongNameRow {
    self.nameLongRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.nameLongText];
}

- (void)addIsOnlineRow {
    self.isOnlineRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.isOnlineText];
}

- (void)addWhereIdRow {
    self.whereIdRow = [self addReadOnlyTextRowWithText:self.deviceViewModel.whereIdText];
}

#pragma mark Override

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initDataManager];
    [self initDeviceUpdateHandlerBlock];

    [self addTitle];
    [self addForm];
    [self addReadonlySection];
    [self addRows];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self addDeviceObservers];

    [self updateTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self removeDeviceObservers];
}

#pragma mark Public

- (void)addTitle {
    self.title = @"Device";
}

- (void)initDataManager {
    self.dataManager = [[NestSDKDataManager alloc] init];
}

- (void)initDeviceUpdateHandlerBlock {
    @weakify(self)
    self.deviceUpdateHandlerBlock = ^(id <NestSDKDevice> device, NSError *error) {
        @strongify(self)
        if (!self) return;

        if (error) {
            NSLog(@"Error updating device: %@", error);

        } else {
            self.deviceViewModel.device = device;
        }

        // Update table view in any case, to set new data or to revert on existing one
        [self updateTableView];
    };
}

- (void)addDeviceObservers {
}

- (void)removeDeviceObservers {
    [self.dataManager removeAllObservers];
}

- (void)addForm {
    self.form = [XLFormDescriptor formDescriptorWithTitle:@"Device details"];
    self.form.delegate = self;
}

- (void)addReadonlySection {
    self.readOnlySection = [XLFormSectionDescriptor formSectionWithTitle:@"Read only properties"];

    [self.form addFormSection:self.readOnlySection];
}

- (void)addReadWriteSection {
    self.readWriteSection = [XLFormSectionDescriptor formSectionWithTitle:@"Read/write properties"];

    [self.form removeFormSection:self.readOnlySection];

    [self.form addFormSection:self.readWriteSection];
    [self.form addFormSection:self.readOnlySection];
}

- (void)addRows {
    [self addDeviceIdRow];
    [self addSoftwareVersionRow];
    [self addStructureIdRow];

    [self addNameRow];
    [self addLongNameRow];

    [self addIsOnlineRow];
    [self addWhereIdRow];
}

- (void)updateDeviceData {
}

- (void)updateTableView {
    [self updateTableViewData];
    [self updateTableViewHeader];
}

- (void)updateTableViewData {
    self.updatingTableViewData = YES;

    self.deviceIdRow.value = self.deviceViewModel.deviceIdText;
    self.softwareVersionRow.value = self.deviceViewModel.softwareVersionText;
    self.structureIdRow.value = self.deviceViewModel.structureIdText;
    self.nameRow.value = self.deviceViewModel.nameText;
    self.nameLongRow.value = self.deviceViewModel.nameLongText;
    self.isOnlineRow.value = self.deviceViewModel.isOnlineText;
    self.whereIdRow.value = self.deviceViewModel.whereIdText;

    [self.tableView reloadData];

    self.updatingTableViewData = NO;
}

- (void)updateTableViewHeader {
}


- (XLFormRowDescriptor *)addReadOnlyTextRowWithText:(NSString *)text {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:nil rowType:XLFormRowDescriptorTypeText title:nil];
    row.value = text;

    [self addReadOnlyRow:row];

    return row;
}

- (void)addReadOnlyRow:(XLFormRowDescriptor *)row {
    row.disabled = @YES;

    [self.readOnlySection addFormRow:row];
}

- (XLFormRowDescriptor *)addReadWriteSwitchRowWithTitle:(NSString *)title boolValue:(NSNumber *)value {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeBooleanSwitch title:title];
    row.value = value;

    [self addReadWriteRow:row];

    return row;
}

- (void)addReadWriteRow:(XLFormRowDescriptor *)row {
    if (!self.readWriteSection) {
        [self addReadWriteSection];
    }

    [self.readWriteSection addFormRow:row];
}

#pragma mark Delegate - XLFormDescriptorDelegate

- (void)formRowDescriptorValueHasChanged:(XLFormRowDescriptor *)formRow oldValue:(id)oldValue newValue:(id)newValue {
    if (self.updatingTableViewData) return;

    if ([oldValue isEqual:newValue]) return;

    [self updateDeviceData];
}

@end