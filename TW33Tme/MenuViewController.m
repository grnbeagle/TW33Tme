//
//  MenuViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/28/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "MenuCell.h"
#import "PersonCell.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"PersonCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    cell.user = [User currentUser];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageTap:)];
    [cell.imageView addGestureRecognizer:tapGestureRecognizer];
    return cell.contentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    [cell setMenuItem:self.menuItems[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuSelected" object:self.menuItems[indexPath.row]  ];
}

- (void)onUserImageTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuSelected" object:profileViewController];
}
@end
