import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

admin.initializeApp(functions.config().firebase);


/* 

################# Push Notification Functions #############################   


*/
//  SAMPLE CODE (DEFAULT CODE)
exports.sendMessage_FCM = functions.firestore.document("fcm/{Uid}").onWrite(async (event) =>{

const uid = event.after.get('userId');
const title = event.after.get('title');
const content = event.after.get('content');

let userDoc = await admin.firestore().doc(`Users/${uid}`).get()
let fcmToken = userDoc.get('fcmToken')


console.log(`userId: ${uid}`)
console.log(`title: ${title}`)
console.log(`content: ${content}`)
await console.log(`fcm: ${fcmToken}`)


const message = {
  notification: {
      title: title,
      body: content,
  },
  apns: {
    payload: {
        aps: {
            sound: 'default',
            type: 'Custom',
        },
    },
},
  token: fcmToken
}

let resp = await admin.messaging().send(message)
console.log(resp)

})




//  REQUESTER CODE (
exports.sendNotification_NewRequest = functions.firestore.document("Requests/{Uid}").onWrite(async (event) =>{

  const uid = event.after.get('requestedTo');
  const title = "New Request"
  const content = "You have a new request";
  
  let userDoc = await admin.firestore().doc(`Users/${uid}`).get()
  let fcmToken = userDoc.get('fcmToken')
  
  
  console.log(`userId: ${uid}`)
  console.log(`title: ${title}`)
  console.log(`content: ${content}`)
  await console.log(`fcm: ${fcmToken}`)
  
  
  const message = {
    notification: {
        title: title,
        body: content,
    },
    apns: {
      payload: {
          aps: {
              sound: 'default',
              type: 'Custom',
          },
      },
  },
    token: fcmToken
  }
  
  let resp = await admin.messaging().send(message)
  console.log(resp)
  
  })



  //  Attendance CODE 
exports.sendNotification_AttedanceRequest = functions.firestore.document("Attendance/{Uid}").onWrite(async (event) =>{


  //Status, CheckIn, CheckOut,
  const status = event.after.get('Status');
  //isVerified == true
  const verified = event.after.get('isVerified');

  var title = ""
  var content = ""

  if (verified == true){
    title = "Attendance Verfied"
    content = "Congratz! Your Attendance has been verified";
  }else{
    if (status == "CheckIn"){
      title = "Mark Attendance"
      content = "Your Babysitter has checked In";
    }else{
      title = "Mark Attendance"
      content = "Your Babysitter has checked Out, Please verify it";
    }

  }

  const uid = event.after.get('requestedTo');
  // const title = "Mark Attendance Request"
  // const content = "You have a new request";
  
  let userDoc = await admin.firestore().doc(`Users/${uid}`).get()
  let fcmToken = userDoc.get('fcmToken')
  
  
  console.log(`userId: ${uid}`)
  console.log(`title: ${title}`)
  console.log(`content: ${content}`)
  await console.log(`fcm: ${fcmToken}`)
  
  
  const message = {
    notification: {
        title: title,
        body: content,
    },
    apns: {
      payload: {
          aps: {
              sound: 'default',
              type: 'Custom',
          },
      },
  },
    token: fcmToken
  }
  
  let resp = await admin.messaging().send(message)
  console.log(resp)
  
  })




    //  Chat CODE 
exports.sendNotification_NewMessage = functions.firestore.document("ChatRoom/{Uid}/Messages/{messageId}").onWrite(async (event) =>{

  const uid = event.after.get('readerID');
  const title = event.after.get('senderName')
  const content = event.after.get('context');
  
  let userDoc = await admin.firestore().doc(`Users/${uid}`).get()
  let fcmToken = userDoc.get('fcmToken')
  
  
  console.log(`userId: ${uid}`)
  console.log(`title: ${title}`)
  console.log(`content: ${content}`)
  await console.log(`fcm: ${fcmToken}`)
  
  
  const message = {
    notification: {
        title: title,
        body: content,
    },
    apns: {
      payload: {
          aps: {
              sound: 'default',
              type: 'Custom',
          },
      },
  },
    token: fcmToken
  }
  
  let resp = await admin.messaging().send(message)
  console.log(resp)
  
  })



/* 

################# Create Stripe Customer on create account #############################   


*/

const currency = functions.config().stripe.currency || 'USD';

const stripe = require('stripe')(functions.config().stripe.token)

// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(async (user) => {
  const customer = await stripe.customers.create({email: user.email});
  return admin.firestore().collection('stripe_customers').doc(user.uid).set({customer_id: customer.id});
});


// Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
exports.addPaymentSource = functions.firestore.document('/stripe_customers/{userId}/tokens/{pushId}').onCreate(async (snap, context) => {
  const source = snap.data();
  const token = source.token;
  console.log('token',token)
  if (source === null){
    return null;
  }

  try {
    const snapshot = await admin.firestore().collection('stripe_customers').doc(context.params.userId).get();
    // const customer =  snapshot.data().customer_id
    const customer =  snapshot.get('customer_id')
    console.log('customer', customer)
    const response = await stripe.customers.createSource(customer, {source: token});
    console.log('response',response)
    return admin.firestore().collection('stripe_customers').doc(context.params.userId).collection("sources").doc(response.fingerprint).set(response, {merge: true});
  } catch (error) {
    console.log('Error in adding card', error)
    //await snap.ref.set({'error':userFacingMessage(error)},{merge:true});
    return reportError(error, {user: context.params.userId});
  }
});


// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]
function reportError(err:any, context = {}) {
  // This is the name of the StackDriver log stream that will receive the log
  // entry. This name can be any valid log stream name, but must contain "err"
  // in order for the error to be picked up by StackDriver Error Reporting.
  const logName = 'errors';
 
  console.log(logName)

  // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
  // const metadata = {
  //   resource: {
  //     type: 'cloud_function',
  //     labels: {function_name: process.env.FUNCTION_NAME},
  //   },
  // };

  // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
  // const errorEvent = {
  //   message: err.stack,
  //   serviceContext: {
  //     service: process.env.FUNCTION_NAME,
  //     resourceType: 'cloud_function',
  //   },
  //   context: context,
  // };

  // Write the error log entry
  return new Promise((resolve, reject) => {
    // log.write(log.entry(metadata, errorEvent), (error) => {
    //   if (error) {
    //    return reject(error);
    //   }
    //   return resolve();
    // });
  });
}



// Sanitize the error message for the user
// function userFacingMessage(error:any) {
//   return error.type ? error.message : 'An error occurred, developers have been alerted';
// }

// [START chargecustomer]
// Charge the Stripe customer whenever an amount is written to the Realtime database
exports.createStripeCharge = functions.firestore.document('stripe_customers/{userId}/charges/{id}').onCreate(async(snap, context) => {
  const val = snap.data();
  try {
    // Look up the Stripe customer id written in createStripeCustomer
    const snapshot = await admin.firestore().collection(`stripe_customers`).doc(context.params.userId).get()
    // const snapval = snapshot.data();
    // const customer = snapval.customer_id
    const customer =  snapshot.get('customer_id')
    // Create a charge using the pushId as the idempotency key
    // protecting against double charges
    const amount = val.amount;
    const idempotencyKey = context.params.id;
    // const source = val.source
    console.log('amount ',amount)
    console.log('currency',currency)
    console.log('customer',customer)
    const charge = {amount, currency, customer};
    const response = await stripe.charges.create(charge, {idempotency_key: idempotencyKey});
    // If the result is successful, write it back to the database
    return snap.ref.set(response, { merge: true });
  } catch(error) {
    // We want to capture errors and render them in a user-friendly way, while
    // still logging an exception with StackDriver
    console.log(error);
    //await snap.ref.set({error: userFacingMessage(error)}, { merge: true });
    return reportError(error, {user: context.params.userId});
  }
});
// [END chargecustomer]]

//sk_test_zfGZl0NlqKK4c46z7k9GtONr00RdqT5FhW




// import * as functions from "firebase-functions";

// // // Start writing Firebase Functions
// // // https://firebase.google.com/docs/functions/typescript
// //
// // export const helloWorld = functions.https.onRequest((request, response) => {
// //   functions.logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });
