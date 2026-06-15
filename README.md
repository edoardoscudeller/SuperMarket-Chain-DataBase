# SuperMarket-Chain-DataBase

Progetto LaTeX per la progettazione e implementazione di un database relazionale per una catena di supermercati.

## Struttura della Repository

```
SuperMarket-Chain-DataBase/
│
├── main.tex                 ← File principale LaTeX (compilare questo)
├── bibliografia.bib         ← Riferimenti bibliografici (BibTeX)
├── .gitignore               ← Ignora file ausiliari LaTeX
│
├── frontespizio/
│   ├── cover.tex            ← Frontespizio (personalizzare con nomi, titoli, ecc.)
│   ├── logo.pdf             ← Logo università (aggiungere manualmente)
│   └── README.md
│
└── immagini/
    ├── README.md            ← Istruzioni per l'uso della cartella
    └── (immagini .pdf/.png) ← Aggiungere le proprie immagini qui
```

## Come compilare

### Con pdflatex (terminale)
```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

### Con latexmk (raccomandato)
```bash
latexmk -pdf main.tex
```

### Con VS Code + LaTeX Workshop
1. Aprire `main.tex`
2. Salvare → compilazione automatica (richiede estensione **LaTeX Workshop**)
3. Il PDF verrà generato nella stessa cartella

## Pacchetti richiesti

I principali pacchetti LaTeX usati (inclusi in TeX Live / MiKTeX):

| Pacchetto | Scopo |
|---|---|
| `babel` (italian) | Supporto lingua italiana |
| `geometry` | Margini pagina |
| `graphicx` | Inclusione immagini |
| `booktabs`, `tabularx` | Tabelle professionali |
| `amsmath`, `amssymb` | Matematica |
| `algorithm`, `algpseudocode` | Pseudocodice algoritmi |
| `listings` | Listati SQL / codice |
| `hyperref` | Link e metadati PDF |
| `minitoc` | Indice per sezione |
| `tikz` | Diagrammi E/R |
| `natbib` | Gestione bibliografia |

## Clonare in locale (cartella Download)

```bash
cd ~/Downloads
git clone https://github.com/edoardoscudeller/SuperMarket-Chain-DataBase.git
```

## Note

- Tutto il testo va inserito in `main.tex`
- Le immagini (schemi E/R, grafici, ecc.) vanno nella cartella `immagini/`
- Il frontespizio si personalizza in `frontespizio/cover.tex`
- I commenti `% TODO:` indicano le sezioni da completare
