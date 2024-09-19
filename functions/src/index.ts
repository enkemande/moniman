import admin from "firebase-admin";
import * as functions from "firebase-functions/v1";

admin.initializeApp();

export const sendTransactionNotification = functions.firestore
  .document("transactions/{transactionId}")
  .onCreate(async (snapshot) => {
    const data = snapshot.data();
    console.log("Transaction created", data);
  });
