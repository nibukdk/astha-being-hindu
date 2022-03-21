const functions = require("firebase-functions"),
    admin = require('firebase-admin');
require('dotenv').config();
admin.initializeApp();

const db = admin.firestore();
// const baseUrlNearBySearch = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
// const api = process.env.API_KEY;

exports.addTimeStampToUser = functions.runWith({
    timeoutSeconds: 120,
    memory: "256MB"
}).firestore.document('users/{userId}').onCreate(async (snapshot, context) => {
    let curTimeStamp = admin.firestore.Timestamp.now();
    functions.logger.log(`curTimeStamp ${curTimeStamp}`);

    try {

        await db.collection('users').doc(context.params.userId).set({ 'registeredAt': curTimeStamp, 'favTempleList': [], 'favShopsList': [], 'favEvents': [] }, { merge: true });
        functions.logger.log(`The current timestamp added to users collection:  ${curTimeStamp}`);
        return { 'status': 200 };
    } catch (e) {
        functions.logger.log(`Something went wrong could not add timestamp to users collectoin ${curTimeStamp}`);
        return { 'status': 400 };
    }
});


exports.addUserLocation = functions.runWith({
    timeoutSeconds: 60,
    memory: "256MB"
}).https.onCall(async (data, context) => {

    try {

        let snapshot = await db.collection('users').doc((context.auth.uid)).get();
        // Check if field value for location is null
        // functions.logger.log(snapshot['_fieldsProto']['userLocation']["valueType"] === "nullValue");
        let locationValutType = snapshot['_fieldsProto']['userLocation']["valueType"];
        if (locationValutType == 'nullValue') {
            await db.collection('users').doc((context.auth.uid)).set({ 'userLocation': data.userLocation }, { merge: true });
            functions.logger.log(`Ùser location added ${data.userLocation}`);

        }
        else {
            functions.logger.log(`Ùser location not changed`);

        }

    }
    catch (e) {
        functions.logger.log(e);
        throw new functions.https.HttpsError('internal', e);
    }
    return data.userLocation;

});

exports.getNearbyTemples = functions.runWith({
    timeoutSeconds: 120,
    memory: "256MB"
}).https.onCall(async (data, context) => {
    // let eventId = context.eventId;
    // const hasProceeded = isEvent
    try {
        functions.logger.log("Add nearby temples function was called");
        let temples = data.templeList.map((temple) => {
            return {
                'place_id': temple['place_id'],
                'address': temple['vicinity'] ? temple['vicinity'] : 'Not Available',
                'name': temple['name'] ? temple['name'] : 'Not Available',
                'latLng': {
                    'lat': temple.hasOwnProperty('geometry') ? temple['geometry']['location']['lat'] : 'Not Available', 'lon': temple.hasOwnProperty('geometry') ? temple['geometry']['location']['lng'] : 'Not Available',
                    'dateAdded': admin.firestore.Timestamp.now()
                },
                'imageRef': data.imageRef
            }
        }

        );

        // functions.logger.log(temples[1]);
        await db.collection('temples').add({ temples: temples });

    } catch (e) {
        return { 'Error Msg': e };
    }
    return temples;
});

exports.addPlacesIdTemples = functions.runWith({
    timeoutSeconds: 120,
    memory: "256MB"
}).firestore.document('temples/{templeId}').onCreate(async (snapshot, context) => {
    const templeList = snapshot.data()['temples'];

    const placesIdList = templeList.map((temple) => temple['place_id']);

    try {
        functions.logger.log("AddPlacessIdTempleslist onCreate was called");
        await db.collection('temples').doc(context.params.templeId).set({ 'palces_id_list': placesIdList }, { merge: true });
    } catch (e) {
        return { 'status': 400 };
    }
    return { 'status': 200 };
});


exports.updateNearbyTemples = functions.runWith({
    timeoutSeconds: 120,
    memory: "256MB"
}).firestore.document('temples/{id}').onUpdate(async (change, context) => {

    if (change.before.exists && change.after.exists) {

        let newTemplesList = change.after.data()['temples'];
        let oldTemplesList = change.before.data()['temples'];

        let oldTemplesIdList = oldTemplesList.map(temple => temple['place_id']);
        let newTemplesIdList = newTemplesList.map(temple => temple['place_id']);

        // Lets find out if theres new temples id by filtering with old one
        let filteredList = newTemplesIdList.filter(x => !oldTemplesIdList.includes(x));
        // if the length are not same of fileted list has 
        //length of 0 then nothing new is there so just return

        if (oldTemplesIdList.length != newTemplesIdList.length || filteredList.length == 0) {
            functions.logger.log("Nothing is changed so onUpdate returned");
            return;
        }

        try {
            functions.logger.log("On Update was called ");

            let temples = newTemplesList.map((temple) => {
                return {
                    'place_id': temple['place_id'],
                    'address': temple['vicinity'] ? temple['vicinity'] : 'Not Available',
                    'name': temple['name'] ? temple['name'] : 'Not Available',
                    'latLng': {
                        'lat': temple.hasOwnProperty('geometry') ? temple['geometry']['location']['lat'] : 'Not Available', 'lon': temple.hasOwnProperty('geometry') ? temple['geometry']['location']['lng'] : 'Not Available',
                        'dateAdded': admin.firestore.Timestamp.now()
                    }
                }
            }
            );

            await db.collection('temples').doc(context.params.id).set({ 'palces_id_list': newTemplesIdList, temples: temples });
        }
        catch (e) { throw e; }
        return { 'status': 200 };
    }
    return null;
});



// Add temple to my fav list:
exports.addToFavList = functions.runWith({
    timeoutSeconds: 120,
    memory: "128MB"
}).https.onCall(async (data, context) => {
    const templeId = data.templeId;
    try {
        let userDocRef = await db.collection('users').doc(context.auth.uid).get();
        let favTempleList = userDocRef._fieldsProto.favTempleList;
        // let favShopsList = userDocRef._fieldsProto.favShopsList;
        // if fav list is empty 
        if (favTempleList.arrayValue.values.length === 0) {
            const templeList = [templeId];
            functions.logger.log("Fav list is empty");

            await db.collection('users').doc(context.auth.uid).set({ favTempleList: templeList }, { merge: true });
            // return { favList: newTemplesList };
        } else {
            functions.logger.log("Fav list is not empty");
            // Make list of available ids
            // firebase providers arrays values as such fileName.arrayValue.values array 
            // consisting dictionary with stringValue key
            let tempArrayValList = favTempleList.arrayValue.values.map(item => item.stringValue);
            // if not empty Check if the temple id already exists
            let hasId = tempArrayValList.includes(templeId);
            // if so remove the id if no just add the list 
            if (hasId === true) {

                // Usr filter to remove value if exists
                let newTemplesList = tempArrayValList.filter(id => id !== templeId);

                await db.collection('users').doc(context.auth.uid).set({ favTempleList: newTemplesList }, { merge: true });
                // return { favList: newTemplesList };

            } else {
                let idList = [...tempArrayValList];
                idList.push(templeId);
                await db.collection('users').doc(context.auth.uid).set({ favTempleList: idList }, { merge: true });
                // return { favList: idList };

            }

        }

    } catch (e) { functions.logger.log(e); }
    return "Done";
});