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
    self.deviceIdRow = [self addReadOnlyTextRowWithTitle:@"Device ID:" text:self.deviceViewModel.deviceIdText];
}

- (void)addSoftwareVersionRow {
    self.softwareVersionRow = [self addReadOnlyTextRowWithTitle:@"Software version:" text:self.deviceViewModel.softwareVersionText];
}

- (void)addStructureIdRow {
    self.structureIdRow = [self addReadOnlyTextRowWithTitle:@"Structure ID:" text:self.deviceViewModel.structureIdText];
}

- (void)addNameRow {
    self.nameIdRow = [self addReadOnlyTextRowWithTitle:@"Name:" text:self.deviceViewModel.nameText];
}

- (void)addLongNameRow {
    self.nameLongIdRow = [self addReadOnlyTextRowWithTitle:@"Long name:" text:self.deviceViewModel.nameLongText];
}

- (void)addIsOnlineRow {
    self.isOnlineIdRow = [self addReadOnlyTextRowWithTitle:@"Online:" text:self.deviceViewModel.isOnlineText];
}

- (void)addWhereIdRow {
    self.whereIdRow = [self addReadOnlyTextRowWithTitle:@"Where ID:" text:self.deviceViewModel.whereIdText];
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
            return;
        }

        self.deviceViewModel.device = device;

        [self updateTableView];
    };
}

- (void)addDeviceObservers {
}

- (void)removeDeviceObservers {
    [self.dataManager removeAllObservers];
}

- (void)addForm {
    self.form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
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

- (void)updateDeviceViewModelData {
}

- (void)setDeviceViewModelData {
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
    self.nameIdRow.value = self.deviceViewModel.nameText;
    self.nameLongIdRow.value = self.deviceViewModel.nameLongText;
    self.isOnlineIdRow.value = self.deviceViewModel.isOnlineText;
    self.whereIdRow.value = self.deviceViewModel.whereIdText;

    [self.tableView reloadData];

    self.updatingTableViewData = NO;
}

- (void)updateTableViewHeader {
}


- (XLFormRowDescriptor *)addReadOnlyTextRowWithTitle:(NSString *)title text:(NSString *)text {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
    row.value = text;

    [self addReadOnlyRow:row];

    return row;
}

- (XLFormRowDescriptor *)addReadOnlyDateTimeRowWithTitle:(NSString *)title date:(NSDate *)date {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeDateTimeInline title:title];
    row.value = date;

    [self addReadOnlyRow:row];

    return row;
}

- (void)addReadOnlyRow:(XLFormRowDescriptor *)row {
    row.disabled = @YES;

    [self.readOnlySection addFormRow:row];
}

- (XLFormRowDescriptor *)addReadWriteTextRowWithTitle:(NSString *)title boolValue:(BOOL)value {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeBooleanSwitch title:title];
    row.value = @(value);

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

    [self updateDeviceViewModelData];
    [self setDeviceViewModelData];
}

@end