const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: 'https://xxxxx.firebaseio.com'
});

const db = admin.firestore();

exports.resetDoseStatus = async (req, res) => {
    try {
        console.log("Starting medication status reset...");

        const usersSnapshot = await db.collection("users").get();
        console.log(`Fetched ${usersSnapshot.size} users from Firestore.`);

        const userPromises = usersSnapshot.docs.map(async (userDoc) => {
            
            const userTimeZone = userDoc.data().timezone || "Etc/UTC";
            const currentTime = new Date().toLocaleString("en-US", { timeZone: userTimeZone, hour: "numeric", hour12: false });
            console.log(`Current time in ${userTimeZone}: ${currentTime}`);

            if (parseInt(currentTime, 10) === 24) {
                const medicationsSnapshot = await userDoc.ref.collection("medications").get();
                console.log(`Fetched ${medicationsSnapshot.size} medications for user ${userDoc.id}.`);

                const medicationPromises = medicationsSnapshot.docs.map(async (medications) => {
                    const doseTimes = medications.data().doseTimes;

                    if (doseTimes) {
                        doseTimes.forEach((dose) => {
                            dose.status = "pending";
                        });
                        await medications.ref.update({ doseTimes: doseTimes });
                        console.log(`Updated medication ${medicationDoc.id} for user ${userDoc.id}.`);
                    }
                });
                await Promise.allSettled(medicationPromises);
            }
        });

        await Promise.allSettled(userPromises);

        console.log("Medication Status Resetted");
    } catch (e) {
        console.error("Error resetting medication status: ", e); 
    }
};
