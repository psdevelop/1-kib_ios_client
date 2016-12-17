//
//  ParseDocProperties.m
//  Uni1CCLient
//
//  Created by MacMini on 29.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParseDocProperties.h"
#import "ParseDocsOperation.h"
#import "CoordinationElement.h"

// NSNotification name for sending props data back to the app delegate
NSString *kAddDocsCoordNotif = @"AddDocsCoordNotif";
NSString *kAddDocsIncludeNotif = @"AddDocsIncludeNotif";
NSString *kDocsPropResultMsgNotif = @"DocsPropResultMsgNotif";

// NSNotification userInfo key for obtaining the props data
NSString *kDocCoordResultsKey = @"DocCoordResultsKey";
NSString *kDocIncludeResultsKey = @"DocIncludeResultsKey";
NSString *kDocsPropMsgResultKey = @"DocsPropMsgResultKey";

@implementation ParseDocProperties

@synthesize docPropertyData, includeDocs, coordTable, currentPaymentDocObject, currentPaymentPlanDocObject;

- (id)initWithData:(NSData *)parseData
{
    if ((self = [super init])) {    
        docPropertyData = [parseData copy];
    }
    return self;
}

- (void)addIncludeDocsPropToList:(NSArray *)docs {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddDocsIncludeNotif object:self userInfo:[NSDictionary dictionaryWithObject:docs forKey:kDocIncludeResultsKey]]; 
}

- (void)addCoordDocsPropToList:(NSArray *)docs {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddDocsCoordNotif object:self userInfo:[NSDictionary dictionaryWithObject:docs forKey:kDocCoordResultsKey]]; 
}

- (void)showDocsPropResultMessage:(SystemMessage *)systemMessage {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDocsPropResultMsgNotif object:self userInfo:[NSDictionary dictionaryWithObject:systemMessage                                    forKey:kDocsPropMsgResultKey]]; 
}

// the main function for this NSOperation, to start the parsing
- (void)main {
    self.includeDocs = [NSMutableArray array];
    self.coordTable = [NSMutableArray array];    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is
    // not desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.docPropertyData];
    [parser setDelegate:self];
    [parser parse];
    
    // depending on the total number of props parsed, the last batch might not have been a
    // "full" batch, and thus not been part of the regular batch transfer. So, we check the count of
    // the array and, if necessary, send it to the main thread.
    //
    //if ([self.includeDocs count] > 0) {
        [self performSelectorOnMainThread:@selector(addIncludeDocsPropToList:)
                               withObject:self.includeDocs
                            waitUntilDone:NO];
    //}
    
    //if ([self.coordTable count] > 0) {
        [self performSelectorOnMainThread:@selector(addCoordDocsPropToList:)
                               withObject:self.coordTable
                            waitUntilDone:NO];
    //}    
    
    self.includeDocs = nil;
    self.coordTable = nil;
    self.currentPaymentDocObject = nil;
    self.currentPaymentPlanDocObject = nil;
    
    [parser release];
}

- (void)dealloc {
    
    [includeDocs release];
    [coordTable release];
    [docPropertyData release];
    [currentPaymentDocObject release];
    [currentPaymentPlanDocObject release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Parser constants

// Limit the number of parsed doc props
static const const NSUInteger kMaximumNumberOfDocsToParse = 150;

static NSUInteger const kSizeOfDocBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kSelDocElementName = @"m:sel_doc";
static NSString * const kSystemErrorElementName = @"php_error";
static NSString * const kSystemWarningElementName = @"php_warning";
static NSString * const kSuccessValueElementName = @"m:success_value";
static NSString * const kPaymentDocListElementName = @"m:payment_doc_list";
static NSString * const kIncludeDocElementName = @"m:include_doc";
static NSString * const kStatementElementName = @"m:statement_item";
static NSString * const kImportanceTypeElementName = @"m:importance_level";
static NSString * const kPaymentFormElementName = @"m:payment_form";
static NSString * const kOrderTypeElementName = @"m:doc_order_type";
static NSString * const kTurnAccountElementName = @"m:turn_account";
static NSString * const kDocGroupTypeElementName = @"m:doc_group_definition";
static NSString * const kBaseDocElementName = @"m:base_doc";
static NSString * const kCFOElementName = @"m:cfo";
static NSString * const kAddTaxName = @"m:add_price_tax";
static NSString * const kExecutorElementName = @"m:executor";
static NSString * const kResponsibleElementName = @"m:responsible_person";
static NSString * const kOrganizationElementName = @"m:organization";
static NSString * const kContragentElementName = @"m:contragent";
static NSString * const kScenaryElementName = @"m:scenary";
static NSString * const kProjectElementName = @"m:project";
static NSString * const kContractElementName = @"m:contract";
static NSString * const kNomenclatureGroupElementName = @"m:nomenclature_group";
static NSString * const kSeasonElementName = @"m:season";
static NSString * const kCurrencyElementName = @"m:charge_currency";
#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // If the number of parsed props is greater than
    // kMaximumNumberOfDocsToParse, abort the parse.

    
    if (parsedDocsCounter >= kMaximumNumberOfDocsToParse) {
        // Use the flag didAbortParsing to distinguish between this deliberate stop
        // and other parser errors.
        //
        didAbortParsing = YES;
        [parser abortParsing];
    }
    
    if ([elementName isEqualToString:kSystemErrorElementName]) {
        SystemMessage *systemMessage = [[SystemMessage alloc] init];
        systemMessage.isShowed = NO;
        systemMessage.message_type_id=1;
        systemMessage.message_caption=@"Системная ошибка сетевого запроса.";
        systemMessage.message_text = [attributeDict valueForKey:@"msg"];
        systemMessage.comment = [attributeDict valueForKey:@"comment"]; 
        systemMessage.doc_id = [attributeDict valueForKey:@"doc_id"];
        
        [self performSelectorOnMainThread:@selector(showDocsPropResultMessage:) withObject:systemMessage waitUntilDone:NO];
        [systemMessage release];
    
    }   else if ([elementName isEqualToString:kSystemWarningElementName]) {
        SystemMessage *systemMessage = [[SystemMessage alloc] init];
        systemMessage.isShowed = NO;
        systemMessage.message_type_id=2;
        systemMessage.message_caption=@"Системное предупреждение звена поставки данных.";
        systemMessage.message_text = [attributeDict valueForKey:@"msg"];
        systemMessage.comment = [attributeDict valueForKey:@"comment"];
        systemMessage.doc_id = [attributeDict valueForKey:@"doc_id"];

        [self performSelectorOnMainThread:@selector(showDocsPropResultMessage:) withObject:systemMessage waitUntilDone:NO];
        
        [systemMessage release];
     
    }   else if ([elementName isEqualToString:kSuccessValueElementName]) {
        SystemMessage *systemMessage = [[SystemMessage alloc] init];
        systemMessage.isShowed = NO;
        systemMessage.message_type_id=3;
        systemMessage.message_caption=[attributeDict valueForKey:@"logical_value"];
        systemMessage.message_text = [attributeDict valueForKey:@"result_text"];
        systemMessage.comment = [attributeDict valueForKey:@"comment"]; 
        systemMessage.doc_id = [attributeDict valueForKey:@"doc_id"];        
        
        [self performSelectorOnMainThread:@selector(showDocsPropResultMessage:) withObject:systemMessage waitUntilDone:NO];
        
        [systemMessage release];
        
    }   else if ([elementName isEqualToString:kStatementElementName]) {
        CoordinationElement *coordElement = [[CoordinationElement alloc] init];
        coordElement.vise_name=[attributeDict valueForKey:@"vise"];
        coordElement.actor_post_name = [attributeDict valueForKey:@"post"];
        coordElement.comment = [attributeDict valueForKey:@"comment"]; 
        coordElement.person_name = [attributeDict valueForKey:@"person_name"]; 
        coordElement.solution_actor_name = [attributeDict valueForKey:@"statement_actor"];
        coordElement.set_date = [[[attributeDict valueForKey:@"set_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString: @"0001-01-01 00:00:00" withString:@"Не установлена"];
        coordElement.max_set_date = [[[attributeDict valueForKey:@"set_max_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString: @"0001-01-01 00:00:00" withString:@"Не установлена"];
        coordElement.setManual = NO;
        if ([[attributeDict valueForKey:@"set_max_date"] isEqualToString:@"true"])  {
            coordElement.setManual = YES;
        }
        coordElement.statement_solution_value = [attributeDict valueForKey:@"solution"]; 
        [self.coordTable addObject:coordElement];
        
        [coordElement release];
        
    }  else if ([elementName isEqualToString:kIncludeDocElementName]) {
        
            PaymentDoc *paymentInPlanDoc = [[PaymentDoc alloc] init];
            [[[currentPaymentPlanDocObject paymentOrderList] paymentDocs] addObject:paymentInPlanDoc]; 
            paymentInPlanDoc.doc_type_id = 1;                      
            paymentInPlanDoc.doc_id = [attributeDict valueForKey:@"doc_id"];          
            paymentInPlanDoc.code = [attributeDict valueForKey:@"doc_code"];            
            paymentInPlanDoc.organization_name = 
            [attributeDict valueForKey:@"org_name"]; 
            paymentInPlanDoc.currency_name = 
            [attributeDict valueForKey:@"curr_name"]; 
            paymentInPlanDoc.doc_summ = 
            [attributeDict valueForKey:@"doc_summ"];
            paymentInPlanDoc.statement_state = [attributeDict valueForKey:@"statement_state"];            
        
        //[self.includeDocs addObject:paymentInPlanDoc];
        currentPaymentDocObject = paymentInPlanDoc;        
        ///[paymentInPlanDoc release];
        
    }   
    
    else if ([elementName isEqualToString:kPaymentFormElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.payment_form_name =  [attributeDict valueForKey:@"payment_form_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.payment_form_name =  [attributeDict valueForKey:@"payment_form_name"];
        //}
        
    } else if ([elementName isEqualToString:kImportanceTypeElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.importance_level_name =  [attributeDict valueForKey:@"importance_level_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.importance_level_name =  [attributeDict valueForKey:@"importance_level_name"];        
        //}        
    } else if ([elementName isEqualToString:kOrderTypeElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.order_type_name =  [attributeDict valueForKey:@"order_type_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kDocGroupTypeElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.doc_group_type_name =  [attributeDict valueForKey:@"doc_group_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kTurnAccountElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.turn_account_name =  [attributeDict valueForKey:@"account_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.turn_account_name =  [attributeDict valueForKey:@"account_name"];        
        //}        
    } else if ([elementName isEqualToString:kBaseDocElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.base_doc_name =  [attributeDict valueForKey:@"base_doc_performance"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kExecutorElementName]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.executor_name=  [attributeDict valueForKey:@"actor_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kResponsibleElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.responsible_name =  [attributeDict valueForKey:@"actor_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.responsible_name =  [attributeDict valueForKey:@"actor_name"];
        //}        
    } else if ([elementName isEqualToString:kOrganizationElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.organization_name =  [attributeDict valueForKey:@"contragent_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.organization_name =  [attributeDict valueForKey:@"contragent_name"];        
        //}        
    } else if ([elementName isEqualToString:kContragentElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.contragent_name =  [attributeDict valueForKey:@"contragent_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kScenaryElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.scenary_name =  [attributeDict valueForKey:@"scenary_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kProjectElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.project_name =  [attributeDict valueForKey:@"project_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.project_name =  [attributeDict valueForKey:@"project_name"];
        //}        
    } else if ([elementName isEqualToString:kContractElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.contract_name =  [attributeDict valueForKey:@"contract_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kNomenclatureGroupElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.nomenclature_group_name =  [attributeDict valueForKey:@"nomenclature_group_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kSeasonElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.seasone_name =  [attributeDict valueForKey:@"season_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kCurrencyElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.currency_name =  [attributeDict valueForKey:@"currency_name"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    } else if ([elementName isEqualToString:kCFOElementName
                ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.cfo_name =  [attributeDict valueForKey:@"contragent_name"];       
        }
        //else if(self.currentPaymentPlanDocObject!=nil)  {
        //    currentPaymentPlanDocObject.cfo_name =  [attributeDict valueForKey:@"contragent_name"];
        //}        
    }  else if ([elementName isEqualToString:kAddTaxName
                 ]) {
        
        if(self.currentPaymentDocObject!=nil)
        {
            currentPaymentDocObject.add_tax_summ =  [attributeDict valueForKey:@"taxe_abs_value"];       
        }
        else if(self.currentPaymentPlanDocObject!=nil)  {
            
        }        
    }    
    else {
        
    }
    if ([elementName isEqualToString:kSelDocElementName]) {
            self.currentPaymentDocObject = nil;
            self.currentPaymentPlanDocObject = nil;
            //if ([[attributeDict valueForKey:@"doc_type_id"] intValue]==docType.doc_type_id) {
                if (([[attributeDict valueForKey:@"doc_type_id"] intValue]==1)||([[attributeDict valueForKey:@"doc_type_id"] intValue]==2)) {
                    PaymentDoc *paymentDoc = [[PaymentDoc alloc] init];
                    self.currentPaymentDocObject = paymentDoc;
                    currentPaymentDocObject.doc_id = [attributeDict valueForKey:@"doc_id"];
                    currentPaymentDocObject.doc_type_id = [[attributeDict valueForKey:@"doc_type_id"] intValue];
                    currentPaymentDocObject.name = [attributeDict valueForKey:@"doc_name"];       
                    currentPaymentDocObject.code = [attributeDict valueForKey:@"doc_code"];
                    currentPaymentDocObject.doc_summ = [attributeDict valueForKey:@"doc_summ"];                
                    currentPaymentDocObject.create_date = [[attributeDict valueForKey:@"create_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    currentPaymentDocObject.charge_max_date = [[attributeDict valueForKey:@"charge_max_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];  
                    currentPaymentDocObject.charge_date = [[attributeDict valueForKey:@"charge_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];                
                    currentPaymentDocObject.statement_state = [attributeDict valueForKey:@"statement_state"];
                    currentPaymentDocObject.statement_date = [[attributeDict valueForKey:@"statement_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    currentPaymentDocObject.enable_statement_set = [attributeDict valueForKey:@"enable_statement_set"];
                    currentPaymentDocObject.comment = [attributeDict valueForKey:@"comment"];
                    currentPaymentDocObject.over_budget = [attributeDict valueForKey:@"over_budget"];
                    currentPaymentDocObject.no_include_in_pay_plan = [attributeDict valueForKey:@"no_include_in_pay_plan"];
                    currentPaymentDocObject.is_exchequer = [attributeDict valueForKey:@"is_exchequer"];                
                    [paymentDoc release];
                    
                }
                else if ([[attributeDict valueForKey:@"doc_type_id"] intValue]==3 ) {
                    PaymentPlanDoc *planDoc = [[PaymentPlanDoc alloc] init];
                    self.currentPaymentPlanDocObject = planDoc;
                    currentPaymentPlanDocObject.doc_id = [attributeDict valueForKey:@"doc_id"];                
                    currentPaymentPlanDocObject.doc_type_id = [[attributeDict valueForKey:@"doc_type_id"] intValue];
                    currentPaymentPlanDocObject.name = [attributeDict valueForKey:@"name"];       
                    currentPaymentPlanDocObject.code = [attributeDict valueForKey:@"doc_code"];
                    currentPaymentPlanDocObject.statement_state = [attributeDict valueForKey:@"statement_state"];
                    currentPaymentPlanDocObject.statement_date = [[attributeDict valueForKey:@"statement_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    currentPaymentPlanDocObject.enable_statement_set = [attributeDict valueForKey:@"enable_statement_set"];
                    currentPaymentPlanDocObject.comment = [attributeDict valueForKey:@"comment"];
                    currentPaymentPlanDocObject.create_date = [[attributeDict valueForKey:@"create_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    currentPaymentPlanDocObject.no_include_in_pay_plan = [attributeDict valueForKey:@"no_include_in_pay_plan"];
                    [planDoc release];
                }
                   
            
        } else if ([elementName isEqualToString:kPaymentDocListElementName]) {
            
            
        }   
        
        else  {
            
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     
    if ([elementName isEqualToString:kIncludeDocElementName]) {
        [self.includeDocs addObject:currentPaymentDocObject];
        // = paymentInPlanDoc;    
    }
    
}


// an error occurred while parsing the doc prop data,
// post the error as an NSNotification to our app delegate.
// 
- (void)handleDocsPropError:(NSError *)parseError {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDocsErrorNotif object:self userInfo:[NSDictionary dictionaryWithObject:parseError forKey:kDocsMsgErrorKey]];
}

// an error occurred while parsing the doc prop data,
// pass the error to the main thread for handling.

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !didAbortParsing)
    {
        [self performSelectorOnMainThread:@selector(handleDocsPropError:)
                               withObject:parseError
                            waitUntilDone:NO];
    }
}

@end
