const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

// NOTE : FIRST TIME YOU HAVE TO INSTALL NPM

// ON_WRITE ::

exports.writeSendNTF = functions.firestore
    .document('/collection_name/{doc_id}')
    .onWrite(async (change, context) => {

// =========================== GET BEFOR AND AFTER VALUE ==============================

        const updatedData = change.after.data();
        const beforeData = change.before.exists ? change.before.data() : null;

// GET DATA USING DOC ID ::

        let data = await admin.firestore().collection("user")
            .doc(updatedData.id).get();
        let details = data.data();

        try {

// GET ALL DATA (COLLECTION) USING WHERE QUERY ::

                let allData = await admin.firestore().collection("collection_name")
                    .where("", "==", "").where("", "==", 1).get();
                let allDetails = allData.docs;

                allDetails.forEach(async element => {

                    let ntfTitle = "New Notification";
                    let msg = "New Notification Message";

                    let payload = {
                        notification: {
                            title: `${ntfTitle}`,
                            body: `${msg}`,
                            click_action: 'FLUTTER_NOTIFICATION_CLICK'
                        },
                    };


// ADD NOTIFICATION IN DB ::

                    AddNotificationDetailsInDB(
                        ntfTitle,
                        msg,
                        "id",
                    );

                    const response = await admin.messaging().sendToDevice(element.data().token, payload);
                    if (response) console.log(" ******* SEND NOTIFICATION SUCCESSFULLY");
                    return response;
                });

        } catch (error) {
            console.log(`!!!!!!! ERROR !!!!!!! ${error}`);
            return null;
        }

    });


// ON CREATE ::

exports.createNFT = functions.firestore
    .document('/col_name/{doc_id}/sub_col_name/{sub_col_id}')
    .onCreate(async (change, context) => {

        const data = change.data();

            try {
                let ntfTitle = "New NFT";
                let msg = "New Notification Message";

                let payload = {
                    notification: {
                        title: `${ntfTitle}`,
                        body: `${msg}`,
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    },
                    // DATA (FOR SEND THE DETAILS IN NOTIFICATION
                    //       AND GET FROM APP SIDE)
                    data: {
                            action: "/check",
                            input: JSON.stringify({
                            a: "A",
                            b: "B",
                            c: "C",
                             }),
                          },
                };


// ADD NOTIFICATION IN DB ::

                AddNotificationDetailsInDB(
                    ntfTitle,
                    msg,
                    "id",
                );

                const response = await admin.messaging().sendToDevice("user_token", payload);
                if (response) console.log(" ******* SEND NOTIFICATION SUCCESSFULLY");
                return response;

            } catch (error) {
                console.log(`!!!!!!! ERROR !!!!!!! ${error}`);
                return null;
            }
    });


// =============================== ADD NOTIFICATION TO DB =============================
// =============================== ADD NOTIFICATION TO DB =============================


function AddNotificationDetailsInDB(
    title, subTitle, ntfRecId,
) {

    try {

        const newColPath = db.collection('collection_name').doc();

        const response = newColPath.set(
            {
                "notification_title": title,
                "notification_sub_title": subTitle,
                "ntf_receiver_id": ntfRecId,
                "is_seen": false,
                "created_at": Date.now(),
            }
        );

        if (response) console.log(" ******* NOTIFICATION DETAILS ADDED SUCCESSFULLY TO DB");

    } catch (error) {
        console.log(`!!!!!!! ERROR WHEN ADD NTF TO DB !!!!!!! ${error}`);
    }

}