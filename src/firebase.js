import firebase from "firebase";
import config from "./config";

const firebaseConfig = {
  apiKey: config.apiKey,
  authDomain: config.authDomain,
  databaseURL: config.databaseURL,
  projectId: config.projectId,
  storageBucket: config.storageBucket,
  messagingSenderId: config.messagingSenderId
};

firebase.initializeApp(firebaseConfig);

const db = firebase.database();
const store = firebase.firestore();
store.settings({
  timestampsInSnapshots: true
});

export default firebase;
export const database = db;
export const firestore = store;
