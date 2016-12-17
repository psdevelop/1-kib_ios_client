/*
  Version: 1.1
 */

#import "Doc.h"

@implementation Doc

@synthesize name, code, create_date, payment_form_name, order_type_name, importance_level_name, statement_date, doc_type_id, doc_id, statement_state, doc_group_type_name, doc_summ, project_name, organization_name, executor_name, responsible_name, cfo_name, turn_account_name, currency_name, currency_rate, charge_date, charge_max_date, enable_statement_set, comment, over_budget, no_include_in_pay_plan, is_exchequer, add_tax_summ, bank_account, pay_target, pay_target_manage;

- (void)dealloc {
    [name release];
    [code release];
    [create_date release];
    [payment_form_name release];
    [order_type_name release];
    [importance_level_name release];
    [statement_date release];
    [doc_id release];
    [statement_state release];
    [doc_group_type_name release];
    [doc_summ release];
    [project_name release];
    [organization_name release];
    [executor_name release];
    [responsible_name release];
    [cfo_name release];
    [turn_account_name release];
    [currency_name release];
    [currency_rate release];
    [charge_date release];
    [charge_max_date release];
    [enable_statement_set release];
    [comment release];
    [over_budget release];
    [no_include_in_pay_plan release];
    [is_exchequer release];
    [add_tax_summ release];
    [bank_account release];
    [pay_target release];
    [pay_target_manage release];
    [super dealloc];
}

@end
