//
//  PrefrencesViewController.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 28/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "PrefrencesViewController.h"
#import "WindowsPathConverterSettings.h"

@interface PrefrencesViewController ()

@property (nonatomic, strong) NSArray* settingsArray;

@end

@implementation PrefrencesViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewWillAppear{
    [super viewWillAppear];
    [self.tableView reloadData];
}
- (IBAction)addButtonPressed:(NSButton *)sender {
    [self.window beginSheet:self.modalWindow completionHandler:^(NSModalResponse returnCode) {
        [self.tableView reloadData];
    }];
}

- (IBAction)subtractButtonPressed:(NSButton *)sender {
    if (self.tableView.selectedRow < 0) return;
    NSTableCellView* cell = [[self.tableView rowViewAtRow:self.tableView.selectedRow makeIfNecessary:NO] viewAtColumn:0];
    [WindowsPathConverterSettings.sharedSettings removeWindowsDriveWithKey: cell.textField.stringValue];
    [self.tableView reloadData];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    self.settingsArray = [self settingsAsArray];
    return self.settingsArray.count;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView* cellView = [tableView makeViewWithIdentifier:@"TableViewCellIdenitifier" owner:self];
    NSUInteger i = [[tableView tableColumns] indexOfObject:tableColumn];
    cellView.textField.stringValue = self.settingsArray[row][i];
    return cellView;
}

-(NSArray*) settingsAsArray
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSDictionary* settings = WindowsPathConverterSettings.sharedSettings.settingsDictionary[@"windows_drives"];
    for (NSString* key in settings) {
        NSMutableArray* element = [[NSMutableArray alloc] init];
        [element addObject:key];
        [element addObject:settings[key]];
        [array addObject:element];
    }
    return [array copy];
}

@end
