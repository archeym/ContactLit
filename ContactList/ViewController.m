//  ViewController.m
//  ContactList
//
//  Created by Arkadijs Makarenko on 21/03/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UISearchBarDelegate >
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) NSMutableArray *phone;
@property (strong, nonatomic) NSMutableArray *textFields;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareContacts];
    [self prepareNumbers];
    [self prepareTableView];
    self.textField.delegate = self;
    _search.delegate = self;
    
}
//set
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    //[self.textField becomeFirstResponder];
    //[self addNewContacts];
    return YES;
}
-(void)prepareTableView{
    self.tableView.dataSource = self;
    //self.tableView.delegate = self;
}
-(void)prepareContacts{
    self.contacts = [@[@"Any Name"] mutableCopy];
}

-(void)prepareNumbers{
    self.phone = [@[@"Phone(303-404-505)"] mutableCopy];
}

-(void)addNewContacts{
    UITextField * nameField = _textFields[0];
    UITextField * phoneFiled = _textFields[1];
    
    NSString *contactName = nameField.text;
    NSString *phoneNumber = phoneFiled.text;
    
    [self.contacts addObject:contactName];
    [self.phone addObject:phoneNumber];
   
   
    [self.textField resignFirstResponder];
    [self.tableView reloadData];
}
#pragma mark - UITableView DataSource
//inplement
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSString *stringToMove = [self.contacts objectAtIndex:sourceIndexPath.row];
    NSString *stringToMove2 = [self.phone objectAtIndex:sourceIndexPath.row];
    [self.contacts removeObjectAtIndex:sourceIndexPath.row];
    [self.contacts insertObject:stringToMove atIndex:destinationIndexPath.row];
    [self.phone removeObjectAtIndex:sourceIndexPath.row];
    [self.phone insertObject:stringToMove2 atIndex:destinationIndexPath.row];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.contacts removeObjectAtIndex:indexPath.row];
            [self.phone removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView setEditing:NO];
        }];
        [alertController addAction:deleteAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cancelAction];
        [self.tableView setEditing:NO];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    //dispaly name
    [cell.textLabel setText:self.contacts[indexPath.row]];
    [cell.detailTextLabel setText:self.phone[indexPath.row]];
    
    return cell;
}
-(void) displayAlert{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"Add New Name" message: @"and Phone Number" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.textColor = [UIColor redColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Phone Number";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [alert addAction: [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:NULL]];
        
        self.textFields = [alert.textFields mutableCopy];
        
        [self addNewContacts];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)edit:(id)sender {
    [self.tableView setEditing:!self.tableView.editing];
   
}
- (IBAction)addNew:(id)sender {
    [self displayAlert];
}

-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    if (swipedCell.textLabel.textColor == [UIColor redColor]) {
        
        [swipedCell.textLabel setTextColor: [UIColor blackColor]];
        
    }else{
    [swipedCell.textLabel setTextColor:[UIColor redColor]];
    
    }
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    [self cellSwipe:sender];
}




@end
