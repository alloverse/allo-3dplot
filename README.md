# Allo 3D Plotter

Allo 3D Plotter is a simple demo project to show how one could
use the Alloverse UI framework to make a simple collaborative
3D VR visualizer. Launch the plotter and walk around inside
your 3D data with your colleagues.

It's currently hard-coded to a single `data.txt` and assumes
that the first column and first rows are axis labels,
and that data values are integers roughly in the range 
of tens-to-hundreds. I'd love to extend this project to
give it dynamic data sources (e g TSV files from URLs);
querying UI to select into the data and to joins;
and controls for colors, scaling, etc.

This is an Alloverse app. You can 
[read about Alloverse app](https://alloverse.com/develop-apps/)
on Alloverse's website.

The current data set is [this xlsx from SCB](https://www.scb.se/hitta-statistik/statistik-efter-amne/befolkning/befolkningens-sammansattning/befolkningsstatistik/pong/tabell-och-diagram/preliminar-statistik-over-doda/).

## Developing

Application sources are in `lua/`.

To start the app and connect it to an Alloplace for testing, run

```
./allo/assist run alloplace://nevyn.places.alloverse.com
```