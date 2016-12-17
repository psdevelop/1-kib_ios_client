/*
  Version: 1.1
 */

#import <Foundation/Foundation.h>

@interface Doc : NSObject {
@private
    NSInteger doc_type_id;
    NSString *doc_id;
    NSString *doc_type_name;
    NSString *doc_type_single_representation;
    NSString *name;
    NSString *code;
    NSString *create_date;
    NSString *statement_state;
    NSString *statement_date;
    NSString *enable_statement_set;
    NSString *payment_form_name;
    NSString *importance_level_name;
    NSString *order_type_name;  
    NSString *doc_summ;
    NSString *doc_group_type_name;
    NSString *turn_account_name;    
    NSString *project_name;
    NSString *organization_name;
    NSString *executor_name;
    NSString *responsible_name;
    NSString *cfo_name;    
    NSString *currency_name;
    NSString *currency_rate;
    NSString *charge_date;
    NSString *charge_max_date;
    NSString *comment;
    NSString *over_budget;
    NSString *no_include_in_pay_plan;
    NSString *is_exchequer;   
    NSString *add_tax_summ;
    NSString *bank_account;
    NSString *pay_target;
    NSString *pay_target_manage;
}

@property (nonatomic, assign) NSInteger doc_type_id;
@property (nonatomic, retain) NSString *doc_id;
@property (nonatomic, retain) NSString *doc_summ;
@property (nonatomic, retain) NSString *statement_state;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *create_date;
@property (nonatomic, retain) NSString *statement_date;
@property (nonatomic, retain) NSString *enable_statement_set;
@property (nonatomic, retain) NSString *payment_form_name;
@property (nonatomic, retain) NSString *importance_level_name;
@property (nonatomic, retain) NSString *order_type_name;
@property (nonatomic, retain) NSString *doc_group_type_name;
@property (nonatomic, retain) NSString *turn_account_name;
@property (nonatomic, retain) NSString *project_name;
@property (nonatomic, retain) NSString *organization_name;
@property (nonatomic, retain) NSString *executor_name;
@property (nonatomic, retain) NSString *responsible_name;
@property (nonatomic, retain) NSString *cfo_name;
@property (nonatomic, retain) NSString *currency_name;
@property (nonatomic, retain) NSString *charge_date;
@property (nonatomic, retain) NSString *charge_max_date;
@property (nonatomic, retain) NSString *currency_rate;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *over_budget;
@property (nonatomic, retain) NSString *no_include_in_pay_plan;
@property (nonatomic, retain) NSString *is_exchequer;
@property (nonatomic, retain) NSString *add_tax_summ;
@property (nonatomic, retain) NSString *bank_account;
@property (nonatomic, retain) NSString *pay_target;
@property (nonatomic, retain) NSString *pay_target_manage;

@end
