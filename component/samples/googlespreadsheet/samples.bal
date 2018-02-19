import wso2.googlespreadsheet;
import ballerina.net.http;

function main (string[] args) {
    endpoint<googlespreadsheet:ClientConnector> googlespreadsheetConnector {
        create googlespreadsheet:ClientConnector(args[1], args[2], args[3], args[4]);
    }

    http:InResponse googlespreadsheetResponse = {};
    http:HttpConnectorError e;
    json googlespreadsheetJSONResponse;

    if (args[0] == "copyTo") {
        googlespreadsheetResponse, e = googlespreadsheetConnector.copyTo(args[5], args[6], args[7], args[8]);
        if(e == null) {
            googlespreadsheetJSONResponse = googlespreadsheetResponse.getJsonPayload();
            println(googlespreadsheetJSONResponse.toString());
        } else {
            println(e);
        }
    }
}
