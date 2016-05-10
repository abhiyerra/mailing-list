console.log('Loading Acksin Mailing List function');

// dependencies
var AWS = require('aws-sdk');

// Get reference to AWS clients
var dynamodb = new AWS.DynamoDB();

exports.handler = function(event, context) {
    switch(event.Action) {
    case "Subscribe":
        subscribe(event.Email, event.Product, event.SignUpPage) {
    case "Unsubscribe":

    case "Email":

    }
}

function subscribe(email, product, signupPage) {
    dynamodb.putItem({
        TableName: config.STORE_TABLE,
        Item: {
            Email: {
                S: email
            },
            Products: {
                S: product
            },
            Notes: {
                SignUpPage: {
                    S: signupPage
                }
            }
        }
    }, function(err, data) {

    });
}
