console.log('Loading Acksin Mailing List Workflow function');

// dependencies
var AWS = require('aws-sdk');

AWS.config.update({
    region: "us-west-2",
});

// Get reference to AWS clients
var dynamodb = new AWS.DynamoDB();

var config = require('./config.json');

exports.handler = function(event, context) {
    dynamodb.scan({
        TableName: config.EMAIL_TABLE
    }, onScan);
}

function onScan(err, data) {
    if (err) {
        console.error("Unable to scan the table. Error JSON:", JSON.stringify(err, null, 2));
    } else {
        // print all the movies
        console.log("Scan succeeded.");
        data.Items.forEach(function(item) {
            console.log(item.Email.S);
        });

        // continue scanning if we have more movies
        if (typeof data.LastEvaluatedKey != "undefined") {
            console.log("Scanning for more...");
            params.ExclusiveStartKey = data.LastEvaluatedKey;
            docClient.scan(params, onScan);
        }
    }
}

exports.handler();
