#import <NestSDK/NestSDKDevice.h>
#import <XLForm/XLForm.h>
#import "DeviceDetailsViewController.h"


@interface DeviceDetailsViewController ()

@property(nonatomic, strong) XLFormSectionDescriptor *section;

@end


@implementation DeviceDetailsViewController
#pragma mark Override

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initForm];
}

- (void)initForm {
    [self addForm];

    [self addSection];

    [self addDeviceIdRow];
    [self addSoftwareVersionRow];
    [self addStructureIdRow];

    [self addNameRow];
    [self addLongNameRow];

    [self addIsOnlineRow];
    [self addWhereIdRow];
}

#pragma mark Public

- (void)addForm {
    self.form = [XLFormDescriptor formDescriptorWithTitle:@"Add Event"];
}

- (void)addSection {
    self.section = [XLFormSectionDescriptor formSection];

    [self.form addFormSection:self.section];
}

- (void)addDeviceIdRow {
    [self addDisabledTextRowWithTitle:@"Device ID:" text:self.device.deviceId];
}

- (void)addSoftwareVersionRow {
    [self addDisabledTextRowWithTitle:@"Software version:" text:self.device.softwareVersion];
}

- (void)addStructureIdRow {
    [self addDisabledTextRowWithTitle:@"Structure ID:" text:self.device.structureId];
}

- (void)addNameRow {
    [self addDisabledTextRowWithTitle:@"Name:" text:self.device.name];
}

- (void)addLongNameRow {
    [self addDisabledTextRowWithTitle:@"Long name:" text:self.device.nameLong];
}

- (void)addIsOnlineRow {
    [self addDisabledTextRowWithTitle:@"Online:" boolValue:self.device.isOnline];
}

- (void)addWhereIdRow {
    [self addDisabledTextRowWithTitle:@"Where ID:" text:self.device.whereId];
}

- (void)addDisabledTextRowWithTitle:(NSString *)title boolValue:(BOOL)value {
    [self addDisabledTextRowWithTitle:title text:value ? @"Yes" : @"No"];
}

- (void)addDisabledTextRowWithTitle:(NSString *)title text:(NSString *)text {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeText title:title];
    row.value = text;

    [self addDisabledRow:row];
}

- (void)addDisabledDateTimeRowWithTitle:(NSString *)title date:(NSDate *)date {
    XLFormRowDescriptor *row = [XLFormRowDescriptor formRowDescriptorWithTag:title rowType:XLFormRowDescriptorTypeDateTimeInline title:title];
    row.value = date;

    [self addDisabledRow:row];
}

- (void)addDisabledRow:(XLFormRowDescriptor *)row {
    row.disabled = @YES;

    [self addFormRow:row];
}

- (void)addFormRow:(XLFormRowDescriptor *)row {
    [self.section addFormRow:row];
}

@end