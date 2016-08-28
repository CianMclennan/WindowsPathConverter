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

@property (nonatomic, strong) WindowsPathConverterSettings* settings;

@end

@implementation PrefrencesViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.settings = [WindowsPathConverterSettings alloc] initWithJSONFilePath:<#(NSURL *)#>
}

-(void)viewWillAppear{
    [super viewWillAppear];
    [self.tableView reloadData];
}
- (IBAction)addButtonPressed:(NSButton *)sender {
}

- (IBAction)subtractButtonPressed:(NSButton *)sender {
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 6;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView* cellView = [tableView makeViewWithIdentifier:@"TableViewCellIdenitifier" owner:self];
    cellView.textField.stringValue = @"test";
    return cellView;
}
//-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    
//}

@end
