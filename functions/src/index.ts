import admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import * as auth from "firebase-functions/v1/auth";
import {getAreaCode} from "./utils/area_codes";
import {ONBOARDING_STEPS} from "./utils/onboarding_steps";

admin.initializeApp();

export const createUserOnSignup = auth.user().onCreate(async (user) => {
  await admin.firestore().collection("users").doc(user.uid).set({
    email: user.email,
    phoneNumber: user.phoneNumber,
    photoUrl: user.photoURL,
    firstName: "",
    lastName: "",
    balance: 0,
    currency: "XAF",
    status: "active",
    createdAt: new Date(),
  });
});

export const initOnboardingSteps = functions.firestore
  .document("users/{userId}")
  .onCreate(async (snapshot, context) => {
    const user = snapshot.data();
    const areaCode = getAreaCode(user.phoneNumber);
    const userOnboardingSteps = ONBOARDING_STEPS.filter((step) =>
      step.areaCodes?.includes(areaCode),
    );
    await Promise.all(
      userOnboardingSteps.map(async (step) => {
        await admin
          .firestore()
          .collection("users")
          .doc(context.params.userId)
          .collection("onboarding_steps")
          .doc(step.type)
          .set({
            name: step.name,
            completed: false,
            skipped: false,
            createdAt: new Date(),
          });
      }),
    );
  });
