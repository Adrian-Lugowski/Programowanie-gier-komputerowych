# Lab 09

## Co zostało zrealizowane
Przygotowano podstawową scenę 3D w silniku Godot 4. Zaimplementowano mechanikę poruszania się z wykorzystaniem węzłów Path3D oraz PathFollow3D, co pozwala na automatyczny postęp kamery i statku wzdłuż wyznaczonej ścieżki. Dodano również sterowanie statkiem za pomocą klawiatury, ograniczając pole manewru funkcją `clamp()`, aby obiekt nie wypadł poza kadr kamery. Prędkość poruszania się po szynie została wyeksportowana jako zmienna `@export`.

## Uruchomienie
1. Pobierz i zainstaluj silnik Godot Engine w wersji 4.x.
2. Otwórz projekt w edytorze, wskazując na plik `project.godot` w folderze `lab_09`.
3. Uruchom główną scenę (`main.tscn`) za pomocą klawisza F5.
