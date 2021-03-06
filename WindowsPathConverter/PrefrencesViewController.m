//
//  PrefrencesViewController.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 28/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "PrefrencesViewController.h"
#import "WindowsPathConverterSettings.h"
#import "PrefrencesWindowController.h"
#import "constants.h"

@interface PrefrencesViewController ()

@property (nonatomic, strong) NSArray* settingsArray;

@property (nonatomic, strong) NSWindow *window;

@end

@implementation PrefrencesViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.window = self.view.window;
    
    // Associate the shortcut view with user defaults
    self.shortCutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    
    self.shouldOpenOnStart.state = WindowsPathConverterSettings.sharedSettings.shouldOpenPreferencesOnStartup;
}

-(void)viewWillAppear{
    [super viewWillAppear];
    [self.tableView reloadData];
}
- (IBAction)addButtonPressed:(NSButton *)sender {
    [[PrefrencesWindowController sharedPrefsWindowController].window beginSheet:self.modalWindow completionHandler:^(NSModalResponse returnCode) {
        [self.tableView reloadData];
    }];
}

- (IBAction)subtractButtonPressed:(NSButton *)sender {
    if (self.tableView.selectedRow < 0) return;
    NSTableRowView* selectedRow = [self.tableView rowViewAtRow:self.tableView.selectedRow makeIfNecessary:NO];
    
    if(selectedRow){
        NSString* macVolume = ((NSTableCellView*)[selectedRow viewAtColumn:0]).textField.stringValue;
        NSString* windowsDrive = ((NSTableCellView*)[selectedRow viewAtColumn:1]).textField.stringValue;
        [WindowsPathConverterSettings.sharedSettings removeWindowsDrive:windowsDrive fromMacVolume:macVolume];
        [self.tableView reloadData];
    }
}

- (IBAction)showPreferencesToggle:(NSButton *)sender {
    WindowsPathConverterSettings.sharedSettings.shouldOpenPreferencesOnStartup = [NSNumber numberWithInteger: sender.state].boolValue;
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
    NSDictionary* settings = WindowsPathConverterSettings.sharedSettings.settingsDictionary[@"volumes"];
    for (NSString* volume in settings) {
        for (NSString* drive in settings[volume]) {
            [array addObject:@[volume, drive]];
        }
    }
    return [array copy];
}

@end
