//
//  RegisterViewController.m
//  TaurusClient
//
//  Created by Tjatse on 12-12-23.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIBarButtonItem+ButtonMaker.h"
#import "UIBarButtonItem+Blocks.h"
#import "MBProgressHUD.h"
#import "ALToastView.h"
#import "BBlock.h"
#import "AppDefines.h"

#define TAG_PHONE   100
#define TAG_VC      101 
#define TAG_PWD     102
#define TAG_CPWD    103


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"注册";
    
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem generateBackStyleButtonWithTitle:@"返回"
                                       andTapCallback:^(id control, UIEvent *event) {
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }];
    
    
    [self initComponent];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Components
#pragma mark initialization
// init tableview.
- (void) initComponent{
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 10, SCREEN_RECT.size.width, SCREEN_RECT.size.height - NAVBAR_HEIGHT - STATUSBAR_FRAME.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundView:nil];
    [_tableView setDataSource:self];
    [_tableView setScrollEnabled:NO];
    [self.view addSubview:_tableView];
    
    // tap gesture.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    recognizer.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:recognizer];
    [recognizer release];
    
    // send sms button
    UIButton *buttonReg = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonReg setBackgroundImage:[UIImage imageNamed:@"fs_btn.png"] forState:UIControlStateNormal];
    [buttonReg setTitle:@"注册" forState:UIControlStateNormal];
    CGFloat x = (SCREEN_RECT.size.width - 278)/2;
    [buttonReg setFrame:CGRectMake(x, NAVBAR_HEIGHT + 170, 278, 45)];
    [buttonReg addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonReg];
    [self.view bringSubviewToFront:buttonReg];
}
// TODO: Change this to the production version.
- (void)registerUser
{
    [self singleTap:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    
    [BBlock dispatchOnSynchronousQueue:^{
        sleep(3);
        // Do something...
        [BBlock dispatchOnMainThread:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ACCOUNT_OPERATION"
                                                                object:nil
                                                              userInfo:[NSDictionary dictionaryWithObject:@"新账户注册成功，请登录。" forKey:@"MSG"]];
        }];
    }];
}
- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    [[_tableView viewWithTag:TAG_PHONE] resignFirstResponder];
    [[_tableView viewWithTag:TAG_CPWD] resignFirstResponder];
    [[_tableView viewWithTag:TAG_VC] resignFirstResponder];
    [[_tableView viewWithTag:TAG_PWD] resignFirstResponder];
}

#pragma mark -TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]
                autorelease];
    }
    [cell setNeedsDisplay];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"手机号";
            UITextField *textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldName setFont:[UIFont systemFontOfSize:14]];
            [textFieldName setPlaceholder:@"请输入您正在使用的手机号码"];
            [textFieldName setReturnKeyType:UIReturnKeyNext];
            [textFieldName setKeyboardType:UIKeyboardTypePhonePad];
            [textFieldName setTag:TAG_PHONE];
            //[textFieldName becomeFirstResponder];
            [textFieldName setDelegate:self];
            [cell addSubview:textFieldName];
            [textFieldName release];
        }
            break;
        case 1: {
            cell.textLabel.text = @"验证码";
            UITextField *textFieldPwd = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldPwd setFont:[UIFont systemFontOfSize:14]];
            [textFieldPwd setSecureTextEntry:YES];
            [textFieldPwd setPlaceholder:@"请输入验证码"];
            [textFieldPwd setKeyboardType:UIKeyboardTypePhonePad];
            [textFieldPwd setReturnKeyType:UIReturnKeyNext];
            [textFieldPwd setTag:TAG_PWD];
            [textFieldPwd setDelegate:self];
            [cell addSubview:textFieldPwd];
            [textFieldPwd release];
            
            UIButton *buttonVC = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [buttonVC addTarget:self action:@selector(sendVCode:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = buttonVC;
        }
            break;
        case 2: {
            cell.textLabel.text = @"密  码";
            UITextField *textFieldPwd = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldPwd setFont:[UIFont systemFontOfSize:14]];
            [textFieldPwd setSecureTextEntry:YES];
            [textFieldPwd setPlaceholder:@"请输入您的密码"];
            [textFieldPwd setKeyboardType:UIKeyboardTypePhonePad];
            [textFieldPwd setReturnKeyType:UIReturnKeyNext];
            [textFieldPwd setTag:TAG_PWD];
            [textFieldPwd setDelegate:self];
            [cell addSubview:textFieldPwd];
            [textFieldPwd release];
        }
            break;
        case 3: {
            cell.textLabel.text = @"密码确认";
            UITextField *textFieldPwd = [[UITextField alloc] initWithFrame:CGRectMake(80, 14, 200, 30)];
            [textFieldPwd setFont:[UIFont systemFontOfSize:14]];
            [textFieldPwd setSecureTextEntry:YES];
            [textFieldPwd setPlaceholder:@"请再次输入您的密码"];
            [textFieldPwd setKeyboardType:UIKeyboardTypePhonePad];
            [textFieldPwd setReturnKeyType:UIReturnKeyNext];
            [textFieldPwd setTag:TAG_CPWD];
            [textFieldPwd setDelegate:self];
            [cell addSubview:textFieldPwd];
            [textFieldPwd release];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_PHONE:
            [[_tableView viewWithTag:TAG_PHONE] becomeFirstResponder];
            break;
        case TAG_PWD:
            [[_tableView viewWithTag:TAG_CPWD] becomeFirstResponder];
            break;
        case TAG_CPWD:
            [[_tableView viewWithTag:TAG_CPWD] resignFirstResponder];
            break;
        default:
            break;
    }
    return true;
}

- (void) sendVCode: (UIButton *)button{
    [self singleTap:nil];
    UITextField *phoneField = (UITextField *)[_tableView viewWithTag:TAG_PHONE];
    if([phoneField text].length > 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"验证码将以短信形式发送到您所填写的手机号码，此短信免收手续费。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        [alert show];
        [alert release];
    }else{
        [phoneField becomeFirstResponder];
    }
}
// TODO: Send SMS here.
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在发送短信...";
            [BBlock dispatchOnSynchronousQueue:^{
                sleep(3);
                [BBlock dispatchOnMainThread:^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self singleTap:nil];
                    [ALToastView toastInView:self.view withText:@"短信已发送，请查收。"];
                }];
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
