import wso2.googlespreadsheet;
import ballerina.net.http;

function main (string[] args) {
    endpoint<googlespreadsheet:ClientConnector> googlespreadsheetConnector {
        create googlespreadsheet:ClientConnector(args[1], args[2], args[3], args[4]);
    }

    googlespreadsheet:Error e = {};
    json googlespreadsheetJSONResponse;

    if (args[0] == "copyTo") {
        googlespreadsheet:SheetProperties googlespreadsheetResponse = {};
        googlespreadsheetResponse, e = googlespreadsheetConnector.copyTo(args[5], args[6], args[7], args[8]);
        if(e == null) {
            println(googlespreadsheetResponse);
        } else {
            println(e);
        }
    } else if (args[0] == "getSpreadSheetValues") {
        googlespreadsheet:ValueRange sheetValuesResponse = {};
        sheetValuesResponse, e = googlespreadsheetConnector.getSpreadSheetValues(args[5], args[6], args[7], args[8], args[9], args[10]);
        if(e == null) {
            println(sheetValuesResponse);
        } else {
            println(e);
        }
    } else if (args[0] == "createSpreadsheet") {
        println("---------Calling createSpreadsheet-----------");
        googlespreadsheet:SpreadsheetProperties spreadsheetProperties = {title:"TestBal"};
        googlespreadsheet:SheetProperties sheetProperties= {title:"testSheet", sheetType:"GRID", sheetId:97};
        googlespreadsheet:Sheet sheet = [];
        sheet.properties = sheetProperties;
        googlespreadsheet:Spreadsheet spreadsheetRequestStruct = {};
        spreadsheetRequestStruct.sheets[0] = sheet;
        spreadsheetRequestStruct.properties = spreadsheetProperties;
        println("####spreadsheetRequestStruct###" + spreadsheetRequestStruct);
        googlespreadsheet:Spreadsheet spreadsheetResponse = {};
        spreadsheetResponse, e = googlespreadsheetConnector.createSpreadsheet(spreadsheetRequestStruct, args[5]);
        if(e == null) {
            println(spreadsheetResponse);
        } else {
            println(e);
        }
    }
}
