import * as readlineSync from "readline-sync";

let arr: number[] = [];

function createElement() {
    const value = Number(readlineSync.question("Enter number to add: "));
    arr.push(value);
    console.log("✅ Element added:", arr);
}

function readElements() {
    if (arr.length === 0) {
        console.log("⚠️ Array is empty");
    } else {
        console.log("📖 Current Array:", arr);
    }
}

function updateElement() {
    const index = Number(readlineSync.question("Enter index to update: "));
    if (index < 0 || index >= arr.length) {
        console.log("⚠️ Invalid index");
        return;
    }
    arr[index] = Number(readlineSync.question("Enter new value: "));
    console.log("✅ Updated Array:", arr);
}

function deleteElement() {
    const index = Number(readlineSync.question("Enter index to delete: "));
    if (index < 0 || index >= arr.length) {
        console.log("⚠️ Invalid index");
        return;
    }
    arr.splice(index, 1);
    console.log("🗑️ After Delete:", arr);
}

// Main Menu
let running = true;
while (running) {
    console.log("\n===== CRUD MENU =====");
    console.log("1. Create");
    console.log("2. Read");
    console.log("3. Update");
    console.log("4. Delete");
    console.log("5. Exit");

    const choice = Number(readlineSync.question("Choose an option: "));

    switch (choice) {
        case 1: createElement(); break;
        case 2: readElements(); break;
        case 3: updateElement(); break;
        case 4: deleteElement(); break;
        case 5:
            console.log("👋 Exiting...");
            running = false;
            break;
        default:
            console.log("⚠️ Invalid choice, try again.");
    }
}