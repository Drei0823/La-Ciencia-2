
---

# ✅ FULL WORKING CODE (index.html)

👉 This is the **clean final version** (Supabase + Mobile + PH Time + Real-time)

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login Tracker</title>

<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<style>
body {
  font-family: Arial;
  background: #f4f4f4;
  margin: 0;
  padding: 15px;
}

.container {
  max-width: 900px;
  margin: auto;
  background: white;
  padding: 15px;
  border-radius: 10px;
}

input {
  width: 100%;
  padding: 10px;
  margin: 5px 0;
}

button {
  padding: 10px;
  margin: 5px 3px;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}

.in { background: green; color: white; }
.out { background: red; color: white; }
.export { background: blue; color: white; }

table {
  width: 100%;
  margin-top: 10px;
  border-collapse: collapse;
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
  font-size: 14px;
}

th {
  background: #333;
  color: white;
}
</style>
</head>

<body>

<div class="container">

<h2>Login & Logout Tracker</h2>

<input id="name" placeholder="Full Name">
<input id="section" placeholder="Section">

<button class="in" onclick="log('IN')">LOG IN</button>
<button class="out" onclick="log('OUT')">LOG OUT</button>
<button class="export" onclick="exportCSV()">EXPORT CSV</button>

<table>
<thead>
<tr>
<th>Name</th>
<th>Section</th>
<th>Action</th>
<th>Time (PH)</th>
</tr>
</thead>
<tbody id="logs"></tbody>
</table>

</div>

<script>
// 🔴 ADD YOUR SUPABASE HERE
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_KEY = "YOUR_SUPABASE_ANON_KEY";

const db = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

let logs = [];

// PH TIME
function phTime() {
  return new Date().toLocaleString("en-US", {
    timeZone: "Asia/Manila"
  });
}

// LOAD DATA
async function load() {
  let { data } = await db
    .from("attendance_logs")
    .select("*")
    .order("id", { ascending: false });

  logs = data || [];
  render();
}

// REALTIME
db.channel("logs")
  .on("postgres_changes",
    { event: "*", schema: "public", table: "attendance_logs" },
    load
  )
  .subscribe();

// LOG ACTION
async function log(action) {
  let name = document.getElementById("name").value;
  let section = document.getElementById("section").value;

  if (!name || !section) return alert("Fill all fields");

  await db.from("attendance_logs").insert([
    {
      name,
      section,
      action,
      timestamp: phTime()
    }
  ]);

  document.getElementById("name").value = "";
  document.getElementById("section").value = "";
}

// RENDER
function render() {
  let table = document.getElementById("logs");
  table.innerHTML = "";

  logs.forEach(l => {
    table.innerHTML += `
      <tr>
        <td>${l.name}</td>
        <td>${l.section}</td>
        <td>${l.action}</td>
        <td>${l.timestamp}</td>
      </tr>
    `;
  });
}

// EXPORT CSV
function exportCSV() {
  let csv = "Name,Section,Action,Time\n";

  logs.forEach(l => {
    csv += `${l.name},${l.section},${l.action},${l.timestamp}\n`;
  });

  let blob = new Blob([csv], {type:"text/csv"});
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "logs.csv";
  a.click();
}

load();
</script>

</body>
</html>
