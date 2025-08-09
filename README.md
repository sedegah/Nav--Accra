# nav--accra

**nav--accra** is a command-line Haskell application that implements Dijkstra’s algorithm to find the shortest route between locations in Accra, Ghana. It uses a predefined graph of 25 key Accra locations and their road distances to compute and display the optimal path and distance between two points.

---

## Features

* Interactive CLI for querying routes between any two of 25 Accra locations.
* Efficient shortest path calculation using Dijkstra’s algorithm.
* Full route reconstruction (shows the entire path, not just distance).
* User-friendly input validation and error handling.
* Looping interface to query multiple routes without restarting.

---

## Getting Started

### Prerequisites

* [GHC (Glasgow Haskell Compiler)](https://www.haskell.org/ghc/) installed on your system.
* Basic familiarity with running commands in a terminal.

### Installation

1. Clone or download the project files.

2. Compile the program using GHC:

   ```bash
   ghc Main.hs -o nav-accra
   ```

3. Run the executable:

   ```bash
   ./nav-accra
   ```

---

## Usage

1. Upon running, the program lists available locations.

2. You will be prompted to enter a **start location** and a **destination location**.

3. The program will compute and display:

   * The shortest distance between the two points (in kilometers).
   * The route taken, listing each intermediate location.

4. You can choose to run additional queries or exit the program.

---

## Sample Run

```
Welcome to the Accra Road Navigator (Dijkstra's algorithm in Haskell)!
Available locations:
Kotoka Airport
Osu
Achimota
Accra Central
Labadi
Madina
Mallam
Circle
Tudu
Tema
Nungua
Teshie
Adenta
Pantang
Abokobi
Ofankor
Spintex
East Legon
University of Ghana
Kwabenya
Adabraka
Kaneshie
Achimota Mall

Enter start location:
Kotoka Airport
Enter destination location:
Tema

Shortest distance from Kotoka Airport to Tema: 38.0 km
Route: Kotoka Airport -> Madina -> Tema

Do you want to find another route? (yes/no)
no
Thank you for using the Accra Road Navigator. Goodbye!
```

---

## Project Structure

* `Main.hs`: Main executable containing all logic for the graph, Dijkstra’s algorithm, CLI, and input handling.

---

## Future Improvements

* Load the graph data from external files (CSV or JSON) for easier updates.
* Integrate real-time traffic data for dynamic route weighting.
* Add A\* search algorithm for optimized pathfinding.
* Implement multi-modal routing (walking, public transport).
* Build a GUI or web interface for enhanced user experience.

---

## License

This project is open source and available under the MIT License.

---

## Contact

Created by Kimathi Sedegah — feel free to reach out with suggestions or questions!

---

If you want, I can help you generate a `LICENSE` file or guide you on publishing your project on GitHub!
