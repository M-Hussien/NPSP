*** Settings ***

Resource        tests/NPSP.robot
Library           DateTime
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser

*** Test Cases ***

BGE Batch With Custom Values
    [tags]  unstable
    ${batch} =           Generate Random String
    Select App Launcher Tab   Batch Gift Entry
    Click BGE Button       New Batch
    Fill BGE Form
    ...                       Name=${batch}
    ...                       Batch Description=This custom batch is created by Robot
    ...                       Expected Count of Gifts=2
    ...                       Expected Total Batch Amount=100
    Click BGE Button        Next
    Select Duellist Values    Opportunity    Available Fields    Donation Name
    Click Duellist Button    Opportunity    Move selection to Selected Fields
    Select Duellist Values    Payment    Selected Fields    Check/Reference Number
    Click Duellist Button    Payment    Move selection to Available Fields
    Click BGE Button        Next
    Select BGE Date Picker    Donation Date: Default Value
    Change BGE month    Next Month
    Pick BGE Date    20
    Select Value From BGE DD    Method    Cash
    Fill BGE Form
    ...                       Donation Amount: Default Value=10
    Click BGE Button        Next
    Fill BGE Form
    ...                       Batch Process Size=100
    ...                       Number of Days from Donation Date=2
    Select Duellist Values    Donation Matching Rule    Selected Fields    Donation Date
    Click Duellist Button    Donation Matching Rule    Move selection to Available Fields
    Select Value From BGE DD    Donation Matching Behavior    Single Match - Only import a record if it matches a single existing record.
    Select BGE Checkbox    Calculate Donation Rollups with Batch
    Click BGE Button        Save
    Verify Title    Batch Gift Entry    ${batch}
    ${field}    Get NPSP Locator    bge.field-input    Donation Name
    Page Should Contain Element    ${field}
    ${field}    Get NPSP Locator    bge.field-input    Payment Check/Reference Number
    Page Should Not Contain Element    ${field}
    ${batch_id}    Get NPSP Record ID
    &{bge_batch} =     Salesforce Get  DataImportBatch__c  ${batch_id}
    Should Be Equal As Strings    &{bge_batch}[Batch_Process_Size__c]    100.0
    Should Be Equal As Strings    &{bge_batch}[Donation_Date_Range__c]    2.0
    Should Be Equal As Strings    &{bge_batch}[Donation_Matching_Behavior__c]    Single Match
    Should Be Equal As Strings    &{bge_batch}[Donation_Matching_Implementing_Class__c]    None
    Should Be Equal As Strings    &{bge_batch}[Donation_Matching_Rule__c]    donation_amount__c
    Should Be Equal As Strings    &{bge_batch}[Expected_Count_of_Gifts__c]    2.0
    Should Be Equal As Strings    &{bge_batch}[Expected_Total_Batch_Amount__c]    100.0
    Should Be Equal As Strings    &{bge_batch}[Post_Process_Implementing_Class__c]    None
    Should Be Equal As Strings    &{bge_batch}[Process_Using_Scheduled_Job__c]    False
    Should Be Equal As Strings    &{bge_batch}[RequireTotalMatch__c]    False
    Should Be Equal As Strings    &{bge_batch}[Run_Opportunity_Rollups_while_Processing__c]    True