const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.congratulateUser = functions.firestore
  .document('Users/{userId}')
  .onUpdate(async (change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue.listPosition === 1 && previousValue.listPosition !== 1) {
      
      // Notify the user who is now in the first position
      const userMessage = {
        notification: {
          title: 'Congratulations!',
          body: 'You are now in the first position!'
        },
        token: newValue.fcmToken
      };

      try {
        await admin.messaging().send(userMessage);
        console.log('Successfully sent message to the new Number1');
      } catch (error) {
        console.log('Error sending message:', error);
      }
      
      // Notify all other users
      const db = admin.firestore();
      const usersRef = db.collection('Users');
      const snapshot = await usersRef.where('listPosition', '!=', 1).get();

      if (snapshot.empty) {
        console.log('No other users found');
        return;
      }

      const otherUsersTokens = [];
      snapshot.forEach(doc => {
        const data = doc.data();
        if (data.fcmToken) {
          otherUsersTokens.push(data.fcmToken);
        }
      });

      const otherUsersMessage = {
        notification: {
          title: 'Attention!',
          body: 'There is a new Number1!'
        },
        tokens: otherUsersTokens
      };

      try {
        await admin.messaging().sendMulticast(otherUsersMessage);
        console.log('Successfully sent message to other users');
      } catch (error) {
        console.log('Error sending message:', error);
      }
    }
  });


// Listen for changes in all documents within the 'Users' collection
exports.sendVoteNotification = functions.region('us-east1').firestore
    .document('Users/{userId}')
    .onUpdate(async (change, context) => {
        // Get an object with the current document value.
        const newValue = change.after.data();

        // Get an object with the previous document value
        const previousValue = change.before.data();

        // Access the parameter `{userId}` with `context.params`
        const userId = context.params.userId;

        if (newValue.numberOfVotesProfile > previousValue.numberOfVotesProfile) {
            // Prepare the message
            const message = {
                notification: {
                    title: 'Someone voted for you!',
                    body: `Your number of votes has been updated to ${newValue.numberOfVotesProfile}`
                },
                token: newValue.fcmToken // Replace this with the actual FCM token for the user
            };
console.log('Token:', newValue.fcmToken)
            // Send the message
            return admin.messaging().send(message)
                .then((response) => {
                    console.log('Successfully sent message:', response);
                })
                .catch((error) => {
                    console.log('Error sending message:', error);
                });
        }
    });

exports.dailyReset = functions.pubsub.schedule('11 11 * * *').timeZone('America/New_York').onRun(async (context) => {
  const db = admin.firestore();


  const promptDoc = await db.collection("theDailyPrompt").doc("thatDailyPrompt").get();
  const dailyPrompt = promptDoc.data().prompt;

  // Fetch the person whose listPosition is 1 (modify as per your data model)
  const topPersonSnapshot = await db.collection("Users").where("listPosition", "==", 1).get();
  let topPersonName = "No One";  // Default
  if (!topPersonSnapshot.empty) {
    const topPersonDoc = topPersonSnapshot.docs[0];
    topPersonName = topPersonDoc.data().name;  // Assuming the name is stored here
  }

  // Store in the History collection (modify fields as needed)
  const historyData = {
    date: admin.firestore.Timestamp.now(),
    dailyPrompt: dailyPrompt,  // The daily prompt you fetched
    topPerson: topPersonName
  };

  await db.collection("History").add(historyData);


  let newPrompt = "No Prompt Yet";

  // Fetch the prompt
  const dailyPromptSnapshot = await db.collection("dailyPrompts").where("promptListPosition", "==", 1).get();
  if (!dailyPromptSnapshot.empty) {
    const dailyPromptDoc = dailyPromptSnapshot.docs[0];
    const dailyPrompt = dailyPromptDoc.data().content;
    const userFcmToken = dailyPromptDoc.data().fcmToken;  // Assuming the FCM token is stored here

    if (dailyPrompt && dailyPrompt !== "") {
      newPrompt = dailyPrompt;

      // Send notification to the user whose prompt was selected
      const message = {
        notification: {
          title: 'Congratulations!',
          body: 'Your prompt was selected as the Daily Prompt!'
        },
        token: userFcmToken
      };

      try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
      } catch (error) {
        console.log('Error sending message:', error);
      }

      await db.collection("theDailyPrompt").doc("thatDailyPrompt").set({ "prompt": newPrompt }, { merge: true });
    }
  }

  // Delete all daily prompts
  const dailyPromptsSnapshot = await db.collection("dailyPrompts").get();
  const batch = db.batch();
  dailyPromptsSnapshot.forEach(doc => {
    batch.delete(doc.ref);
  });
  await batch.commit();

  // Update users
  const usersSnapshot = await db.collection("Users").get();
  const userBatch = db.batch();
  usersSnapshot.forEach(doc => {
    userBatch.update(doc.ref, {
      "isSelected": false,
      "hasVoted": false,
      "hasVotedForPrompt": false,
      "listPosition": 0,
      "numberOfVotesProfile": 0,
      "votedForMe": [],
      "comments": []
    });
  });
  await userBatch.commit();

const allUsersSnapshot = await db.collection("Users").get();
  const allUserTokens = [];
  
  allUsersSnapshot.forEach(doc => {
    const fcmToken = doc.data().fcmToken;
    if (fcmToken) {
      allUserTokens.push(fcmToken);
    }
  });

  const notificationMessage = {
    notification: {
      title: "🥇THE DAILY QUESTION IS HERE!🏆",
      body: "Go vote for the person of your choice and for tomorrow's statement."
 },
  apns: {
    payload: {
      aps: {
        sound: "default"
      }
    }
  },
  tokens: allUserTokens
};
  
    try {
    const response = await admin.messaging().sendMulticast(notificationMessage);
    console.log('Successfully sent daily question notification:', response);
    // Log the status of individual messages in the batch
    response.responses.forEach((resp, idx) => {
      if (!resp.success) {
        console.log(`Message failed to send to index ${idx}: ${JSON.stringify(resp)}`);
      }
    });
  } catch (error) {
    console.log('Error sending daily question notification:', error.message, error.code, JSON.stringify(error));
  }
  

  console.log("Daily reset complete!");
  return null;
});


