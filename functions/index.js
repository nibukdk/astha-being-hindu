const functions = require("firebase-functions"),
    nodeHttp = require('https'),
    admin = require('firebase-admin');
require('dotenv').config();
admin.initializeApp();

const db = admin.firestore();
// const baseUrlNearBySearch = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";
// const api = process.env.API_KEY;

exports.addUserLocation = functions.https.onCall(async (data, context) => {

    try {

        let snapshot = await db.collection('users').doc((context.auth.uid)).get();
        // functions.logger.log(snapshot['_fieldsProto']['userLocation']["valueType"]);
        // Check if field value for locatio is null
        console.log(snapshot['_fieldsProto']['userLocation']);
        let locationValutType = snapshot['_fieldsProto']['userLocation']["valueType"];

        if (locationValutType == 'nullValue') {
            db.collection('users').doc((context.auth.uid)).set({ 'userLocation': data.userLocation }, { merge: true });
            functions.logger.log(`Ùser location added ${data.userLocation}`);
        }
        else {
            functions.logger.log(`Ùser location not changed`);
            return;
        }

    }
    catch (e) {
        throw e;
    }
    return data.userLocation;

});



exports.getNearbyTemples = functions.runWith({
    timeoutSeconds: 180,
    memory: "256MB",
}).https.onCall(async (data, context) => {
    // let eventId = context.eventId;
    // const hasProceeded = isEvent
    let templeList = [];
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
                }
            }
        }

        );
        templeList = [...temples];
        // functions.logger.log(temples[1]);
        await db.collection('temples').add({ temples: temples });

    } catch (e) {
        throw e;
    }

    return templeList;

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
    } catch (e) { throw e; }
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

