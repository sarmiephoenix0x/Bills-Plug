const AWS = require('aws-sdk');
const admin = require('firebase-admin');
const secretsManager = new AWS.SecretsManager({ region: 'us-east-1' });

// Function to retrieve the Firebase credentials secret
async function getFirebaseCredentials() {
    try {
        const data = await secretsManager.getSecretValue({ SecretId: "firebase-credentials" }).promise();
        if (data.SecretString) {
            // Parse the outer SecretString object first
            const parsedSecret = JSON.parse(data.SecretString);
            // Now parse the actual credentials JSON inside the 'firebase-credentials' field
            const credentials = JSON.parse(parsedSecret['firebase-credentials']);

            // Ensure correct formatting of private_key (replace \\n with actual newlines)
            credentials.private_key = credentials.private_key.replace(/\\n/g, '\n');

            // Return the fixed credentials
            return credentials;
        }
        throw new Error("SecretString is empty");
    } catch (err) {
        console.error("Error retrieving Firebase credentials:", err);
        throw err;
    }
}

// Lambda handler function
exports.handler = async (event) => {
    try {
        // Retrieve the Firebase credentials from AWS Secrets Manager
        const firebaseCredentials = await getFirebaseCredentials();

        // Initialize Firebase Admin SDK using the retrieved credentials
        admin.initializeApp({
            credential: admin.credential.cert(firebaseCredentials),
        });

        // Ensure the HTTP method is POST
        if (event.httpMethod !== 'POST') {
            return {
                statusCode: 403,
                body: JSON.stringify({ error: 'Forbidden! This function only accepts POST requests.' }),
            };
        }

        // Parse the request body and extract the registration token
        const body = JSON.parse(event.body);
        const registrationToken = body.token;

        if (!registrationToken) {
            return {
                statusCode: 400,
                body: JSON.stringify({ error: 'Error: No registration token provided.' }),
            };
        }

        // Define the notification message
        const message = {
            notification: {
                title: "Hello!",
                body: "This is a push notification.",
            },
            token: registrationToken,
        };

        // Send the notification using Firebase Cloud Messaging
        const response = await admin.messaging().send(message);
        console.log("Successfully sent message:", response);

        return {
            statusCode: 200,
            body: JSON.stringify({ success: "Notification sent successfully" }),
        };
    } catch (error) {
        console.error("Error sending message:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Error sending notification' }),
        };
    }
};
