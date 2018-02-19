# Google Spreadsheet Connector

   The Google Spreadsheet connector allows you to access the Google Spreadsheet API Version v4 through Ballerina.
   Google Sheets is an online spreadsheet that lets users create and format spreadsheets and simultaneously work with other people.
   The following section provide you the details on connector operations.

## copyTo
  This action allows you to Copy a single sheet from a spreadsheet to another spreadsheet. Returns the properties of the newly created sheet.

###### Properties
  * spreadsheetId :- Unique value of the spreadsheet.
  * sheetId :- The ID of the sheet to copy.
  * destinationSpreadsheetId :- The ID of the spreadsheet to copy the sheet to.
  * fields :- Specifying which fields to include in a partial response.

###### Related Google Spreadsheet documentation
  [copyTo](https://developers.google.com/sheets/reference/rest/v4/spreadsheets.sheets/copyTo)

## How to use

###### Prerequisites

1. Create a project and create an app for this project by visiting [Google Spreadsheet](https://console.developers.google.com/)
2. Obtain the following parameters
   * Client Id
   * Client Secret
   * Redirect URI
   * Access Token
   * Refresh Token

    **IMPORTANT** This access token and refresh token can be used to make API requests on your own
account's behalf. Do not share your access token, client  secret with anyone.


###### Invoke the actions

- copy package-googlespreadsheet/sample/googlespreadsheet/samples.bal into `<ballerina_home>`/bin$ folder
- To run the actions of the Google Spreadsheet connector run the below command for relevant actions.

###### NOTE

If the template parameter is indicate as optional you must pass null as default value to run this
action.

1. copyTo
    `bin$ ./ballerina run samples.bal copyTo <accessToken:-Required> <clientId:-Optional> <clientSecret:-Optional>
     <spreadsheetId:-Required> <sheetId:-Required> <refreshToken:-Optional> <destinationSpreadsheetId:-Required> <fields:-Optional>`

