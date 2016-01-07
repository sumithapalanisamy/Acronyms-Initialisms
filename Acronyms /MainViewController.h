//
//  MainViewController.h
//  Acronyms
//
//  Created by Sumitha Palanisamy on 1/6/16.
//  Copyright (c) 2016 Sumitha Palanisamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,weak) IBOutlet UITextField *dataTxtField;
@property (weak, nonatomic) IBOutlet UITableView *abbrevTableView;
@property (retain, nonatomic)NSMutableArray *allDataArray;

@end
