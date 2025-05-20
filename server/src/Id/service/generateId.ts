import admin from "../../firebase"; // Import Firestore instance

const db = admin.firestore();
// Fungsi untuk mendapatkan ID baru untuk Task atau Schedule
async function getNewId(counterType: "task" | "schedule"): Promise<string> {
  const counterDocRef = db.collection("counters").doc(`${counterType}Counter`);

  // Mulai transaction untuk mendapatkan nilai counter
  const counterDoc = await counterDocRef.get();

  if (!counterDoc.exists) {
    // Jika dokumen belum ada, buat dokumen dengan nilai awal 0
    await counterDocRef.set({count: 0});
  }

  const newCount = counterDoc.exists ? counterDoc.data()?.count + 1 : 1;

  // Perbarui nilai count untuk counter
  await counterDocRef.update({count: newCount});

  // Return ID dengan format yang diinginkan
  return `${counterType.toUpperCase()}${String(newCount).padStart(3, "0")}`;
}

export default getNewId;
