// Use the REDCap Cypress Test Framework configuration that is right for you!

// ==== START: BASIC CONFIGURATION OPTION ===== //
// If you decide not to use this option, comment out the line below before using a different configuration
//import 'rctf'
// ==== END: BASIC CONFIGURATION OPTION ===== //

// ==== START: ADDITIONAL CONTROL OPTION ===== //
// Uncomment this section if you want to create your own before() block for some reason
// import { rctf_initialize } from 'rctf'
//
// before(() => {
//     //Do whatever you want before and after the basic initialization below
//     rctf_initialize()
// })
// ==== END: ADDITIONAL CONTROL OPTION ===== //

// ==== START: FULL CONTROL OPTION ===== //
// Uncomment this section if you want to manage ALL the methods yourself
// import  {
//     load_core_commands,
//     preserve_cookies,
//     intercept_vanderbilt_requests,
//     set_user_info,
//     reset_database,
//     set_timezone,
//     load_support_files
// } from 'rctf'
//
// before(() => {
    //Do whatever you want you in addition to the basic RCTF framework methods below
    // load_core_commands()
    // preserve_cookies()
    // intercept_vanderbilt_requests()
    // set_user_info()
    // reset_database()
    // set_timezone()
    // load_support_files()
// })
// ==== END: FULL CONTROL OPTION ===== //


// ==== START: BEFORE EACH SCENARIO BLOCK ===== //
// Uncomment if you want to perform any steps before EVERY scenario
// beforeEach(() => {
//     //Do whatever you want you in addition to the basic RCTF framework here
// })
// ==== END: BEFORE EACH SCENARIO BLOCK ===== //

import 'cypress-axe'
require('./commands')