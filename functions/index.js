const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification =
    functions.https.onRequest((req, res) => {
        const registrationToken =
            req.body.token;
  const message = {
    notification: {
      title: "Hello!",
      body: "This is a push notification.",
    },
    token: registrationToken,
  };

  admin.messaging().send(message)
    .then((response) => {
        console.
            log(
                "Successfully sent message:",
                response);
        res.
            status(200).
            send("Notification sent successfully");
    })
    .catch((error) => {
        console.
            log("Error sending message:", error);
        res.
            status(500).
            send("Error sending notification");
    });
}); // Ensure there is a newline at the end of the file.