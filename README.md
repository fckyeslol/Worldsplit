# Worldsplit

Worldsplit is a fast-paced 2D action platformer built with **Godot 4**, focused on fluid movement, responsive combat, and tight gameplay mechanics.

The player navigates through dangerous environments, avoiding hazards and fighting enemies using precise controls and timing.

---

## 🚀 Play the Game

> https://fckyeslol.itch.io/worldsplit

---

## 🛠️ Built With

* **Engine:** Godot 4
* **Language:** GDScript
* **Platform:** Desktop / Web (HTML5)

---

## 🎯 Core Features

* ⚔️ Responsive melee combat system
* 🌀 Rolling mechanic with stamina system
* ❤️ Health and damage system
* 👾 Enemy interactions and hit detection
* 🌍 Multiple scenes and level structure
* 🎮 Smooth and responsive movement

---

## 🎮 Controls

| Action | Key / Input             |
| ------ | ----------------------- |
| Move   | **W / A / S / D**       |
| Roll   | **E**                   |
| Attack | **Double Left Click**   |

---

## ⚙️ How to Run Locally

### 1. Install Godot

Download **Godot 4** from:
https://godotengine.org/download

---

### 2. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/Worldsplit.git
cd Worldsplit
```

---

### 3. Open the Project

* Open Godot
* Click **Import**
* Select the file:

```text
project.godot
```

* Click **Import & Edit**

---

### 4. Run the Game

Press the **Play (▶️)** button inside Godot.

---

## 🌐 Running the Web Build (Optional)

If you exported the game to HTML5:

### Run a local server:

```bash
python -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

> ⚠️ Do NOT open `index.html` directly. Use a local server.

---

## 🧠 Gameplay Mechanics

### 🏃 Movement

* Smooth horizontal movement with acceleration
* Gravity-based jumping system

### 🌀 Roll System

* Activated with **E**
* Consumes stamina
* Temporary speed boost
* Has cooldown to prevent spam

### ⚔️ Combat System

* Attack using **double left click**
* Directional attack based on player facing
* Hitbox-based enemy detection

### ❤️ Health System

* Player takes damage from enemies
* Health bar updates dynamically
* Death triggers scene reload

---

Project Structure

```text
Worldsplit/
├── Assets/        # Game assets (sprites, fonts, etc.)
├── Scenes/        # Game scenes and scripts
├── images/        # Additional images
├── addons/        # Plugins (optional)
├── project.godot  # Main project file


Author

Developed by **Mateo Pirela**
Passionate about building interactive systems, games, and real-world tech solutions.

---

License

This project is open-source and available for learning and experimentation.
