import "./main.css";
import { Elm } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";
import { database } from "./firebase";

const app = Elm.Main.init({
  node: document.getElementById("root")
});

app.ports.toFirebase.subscribe(counter => {
  console.log("Elm sent to Firebase: " + counter);
  database.ref("counter").set(counter);
});

database.ref("counter").on("value", counter => {
  console.log("Firebase sent to Elm: ", counter.val());
  app.ports.fromFirebase.send(counter.val());
});

registerServiceWorker();
