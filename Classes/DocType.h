/*
     File: DocType.h
 Abstract: The model class that stores the information about an doc type.
  Version: 1.1
 
 */

#import <Foundation/Foundation.h>

@interface DocType : NSObject {
@private
    // Magnitude of the earthquake on the Richter scale.
    //CGFloat magnitude;
    // Name of the location of the earthquake.
    NSInteger doc_type_id;
    NSString *name;
    NSString *description;
    NSString *img_file;    
    /*// Date and time at which the earthquake occurred.
    NSDate *date;
    // Holds the URL to the USGS web page of the earthquake. The application uses this URL to open that page in Safari.
    NSURL *USGSWebLink;
    // Latitude and longitude of the earthquake. These properties are not displayed by the application, but are used to  
    // create a URL for opening the Maps application. They could alternatively be used in conjuction with MapKit 
    // to be shown in a map view.
    double latitude;
    double longitude;*/
}

@property (nonatomic, assign) NSInteger doc_type_id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *img_file;

@end
