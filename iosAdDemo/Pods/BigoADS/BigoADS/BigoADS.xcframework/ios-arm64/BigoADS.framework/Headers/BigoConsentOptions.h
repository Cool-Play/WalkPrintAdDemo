//
//  BigoConsentOptions.h
//  Pods
//
//  Created by cai on 2023/5/22.
//  Description: user consent options
//

#ifndef BigoConsentOptions_h
#define BigoConsentOptions_h

typedef enum {
    BigoConsentOptionsGDPR, /* @see <a href="https://iabeurope.eu/gdpr/">GDPR</a> */
    BigoConsentOptionsCCPA, /* @see <a href="https://www.iab.com/topics/privacy/ccpa/">CCPA</a> */
    BigoConsentOptionsLGPD, /* @see <a href="https://lgpd-brazil.info/">LGPD<a/> */
    BigoConsentOptionsCOPPA /* @see <a href="https://www.ftc.gov/business-guidance/privacy-security/childrens-privacy">COPPA<a/> */
    
} BigoConsentOptions;

#endif /* BigoConsentOptions_h */
