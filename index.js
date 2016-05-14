console.log('Loading Acksin Mailing List function');

// dependencies
var AWS = require('aws-sdk');

// Get reference to AWS clients
var dynamodb = new AWS.DynamoDB();

exports.handler = function(event, context) {
    switch(event.Action) {
    case "Subscribe":
        subscribe(event.Email, event.Product, event.SignUpPage, context);
    case "Unsubscribe":
        unsubscribe(event.Email, event.Reason, context);
    }
}

function subscribe(email, product, signupPage, context) {
    dynamodb.putItem({
        TableName: config.EMAIL_TABLE,
        Item: {
            Email: {
                S: email
            },
            Products: {
                S: product
            },
            CreatedAt: {
                S: new Date().toISOString()
            }
            Notes: {
                SignUpPage: {
                    S: signupPage
                }
            }
        }
    }, function(err, data) {
        if(err != nil) {
            context.fail(err);
        }

        context.done();
    });
}

function unsubscribe(email) {
    dynamodb.deleteItem({
        TableName: config.EMAIL_TABLE,
        Key: {
            "Email": email
        }
    }, function(err, data) {
        if(err != nil) {
            context.fail(err);
        }

        context.done();
    });
}
