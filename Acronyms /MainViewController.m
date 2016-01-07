//
//  MainViewController.m
//  Acronyms
//
//  Created by Sumitha Palanisamy on 1/6/16.
//  Copyright (c) 2016 Sumitha Palanisamy. All rights reserved.
//

#import "MainViewController.h"
#import "ServiceRequest.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"

#define MAXLENGTH 30
@interface MainViewController ()<ServiceDelegate>
{
    MBProgressHUD *progressHud;
    NSMutableArray *allAbbrievationDataArray;
    NSMutableArray *allDetailedDataArray;
}
@property (nonatomic, strong) NSCharacterSet *disallowedCharacters;;

@end

@implementation MainViewController
@synthesize allDataArray;

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Only alpha-numeric characters are allowed to enter in textfield.
    self.disallowedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.labelText = @"Loading Data..";
    [self.view addSubview:progressHud];
    [self.abbrevTableView setHidden:YES];
    self.allDataArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Button Action method
//Validating Maximum and Minimum characters allowed for an Acronym

- (IBAction)sendClicked:(id)sender {
    
    if ([self.dataTxtField.text length] <=1 || [self.dataTxtField.text length] > MAXLENGTH) {
        [self alertUser:@"Please enter a valid input"];
    }
    else {
        [self.dataTxtField resignFirstResponder];
        [progressHud show:YES];
        //service request to get acronym related data
        ServiceRequest *serviceRequest = [[ServiceRequest alloc] init];
        serviceRequest.serviceDelegate = self;
        [serviceRequest getDataFromServer:self.dataTxtField.text];
    }
}

- (void)alertUser:(NSString*)messageStr{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!!" message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark Service Delegate methods
//success delegate
- (void)dataRecieved:(id)dataDictionary{
    [progressHud hide:YES];
    
    NSDictionary *allDataDictionary = [dataDictionary firstObject];
   
    if (allDataDictionary == nil) {
        [self alertUser:@"Could not find anything related to your search keyword."];
        return;
    }
    
    allDataArray = [allDataDictionary objectForKey:@"lfs"];
    [self.abbrevTableView setHidden:NO];
    [self.abbrevTableView reloadData];
}


//failure delegate
- (void)dataError:(NSString*)errorStr{
    [progressHud hide:YES];
    [self alertUser:@"Please check you network connection and try again.."];
}

#pragma mark UITextfield Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[textField becomeFirstResponder];
    [self.abbrevTableView setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    // Dismiss Keyboard on return
    [textField resignFirstResponder];
   
    if(![textField.text isEqualToString:@""]){
        
        if ([self.dataTxtField.text length] <=1 || [self.dataTxtField.text length] > MAXLENGTH) {
            [self alertUser:@"Please enter a valid input"];
        }
        else {
            [progressHud show:YES];
            //service request to get acronym related data
            ServiceRequest *serviceRequest = [[ServiceRequest alloc] init];
            serviceRequest.serviceDelegate = self;
            [serviceRequest getDataFromServer:self.dataTxtField.text];
        }
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    
    return (newLength <= MAXLENGTH || ([string rangeOfString: @"\n"].location != NSNotFound)) && ([string rangeOfCharacterFromSet:self.disallowedCharacters].location == NSNotFound);
}

#pragma mark- UITableView Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSDictionary *dict = [allDataArray objectAtIndex:indexPath.row];
     
    cell.textLabel.text = [dict objectForKey:@"lf"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@" %@ occurences since %@", [dict objectForKey:@"freq"],[dict objectForKey:@"since"] ];
    return cell;
}


#pragma mark- UITableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
      return 50.0;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"detailViewController"]) {
        NSIndexPath *indexPath = [self.abbrevTableView indexPathForSelectedRow];
        DetailViewController *destinationViewController = [segue destinationViewController];
        NSDictionary *dict = [allDataArray objectAtIndex:indexPath.row];
        destinationViewController.detailMeaningArray = [dict objectForKey:@"vars"];
    }
    
}


@end
