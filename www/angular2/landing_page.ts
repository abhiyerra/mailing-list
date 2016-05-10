import {Component, Input} from 'angular2/core';

@Component({
    selector: 'acksin-subscribe',
    template: `
<form action="" class="form" method="post">
<input name="email" placeholder="Your email address" type="email" class="form-control" [(ngModel)]="emailAddress" >
<br>
<button (click)="submit()" type="submit" class="btn btn-success">Subscribe</button>
</form>

<p>{{response}}</p>`
})
export class AcksinSubscribe {
    emailAddress: string = '';
    response: string = '';
    product: string = '';

    constructor() {
        if acksinProduct != undefined {
            this.product = acksinProduct;
        }
    }

    submit() {
        var lambda = new AWS.Lambda();
        var that = this;

        ga('send', 'event', 'Subscribe', this.product, 'Subscribe' + this.product + 'Email');

        lambda.invoke({
            FunctionName: 'landing_page_emails_POST',
            Payload: JSON.stringify({
                "Email": this.emailAddress,
                "Product": this.product
            }),
        }, function(err, data) {
            if (err) {
                console.log(err, err.stack);
            }

            console.log(data.Payload);
            that.response = "Thank you for your interest. We will be in touch.";
        });
    }
}
