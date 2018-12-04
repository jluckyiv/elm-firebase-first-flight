import "./main.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import { database } from "./firebase";
import { firestore } from "./firebase";

const app = Elm.Main.init({
  node: document.getElementById("root")
});

app.ports.toFirebase.subscribe(message => {
  const [key, value] = message;
  console.log("Elm sent to Firebase: ", key, value);
  database.ref(key).push(value);
});

database.ref("messages").on("value", messages => {
  console.log("Firebase sent to Elm: ", messages.val());
  app.ports.fromFirebase.send(["messages", messages.val()]);
});

app.ports.toFirestore.subscribe(message => {
  const [key, value] = message;
  console.log("Elm sent to Firestore: ", key, value);
  firestore.collection(key).add({"message": value});
});

firestore.collection("messages").onSnapshot(querySnapshot => {
  let messages = {};
  querySnapshot.forEach(doc => {
    messages[doc.id] = doc.data().message;
  });
  console.log("Firestore sent to Elm: ", messages);
  app.ports.fromFirestore.send(["messages", messages]);
});

window.database = database;
window.firestore = firestore;

registerServiceWorker();
