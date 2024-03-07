const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.dailyReset = functions.pubsub.schedule('11 11 * * *').timeZone('America/New_York').onRun(async (context) => {
  const db = admin.firestore();
  let newPrompt = "No Prompt Yet";

  // Fetch the prompt
  const dailyPromptSnapshot = await db.collection("dailyPrompts").where("promptListPosition", "==", 1).get();
  if (!dailyPromptSnapshot.empty) {
    const dailyPrompt = dailyPromptSnapshot.docs[0].data().content;
    if (dailyPrompt && dailyPrompt !== "") {
      newPrompt = dailyPrompt;
    }
    await db.collection("theDailyPrompt").doc("thatDailyPrompt").set({ "prompt": newPrompt }, { merge: true });
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
      "votedForMe": []
    });
  });
  await userBatch.commit();

  console.log("Daily reset complete!");
  return null;
});

