# Cartella `frontespizio/`

Questa cartella contiene il file del frontespizio del documento LaTeX.

## Personalizzazione

Modifica `cover.tex` per inserire:
- Logo dell'università (file `.pdf` o `.png`)
- Nome università e dipartimento
- Corso di laurea / corso
- Titolo del progetto
- Nome del docente / relatore
- Nome e matricola degli studenti
- Anno accademico

## File immagine del logo

Copiere il file del logo universitario in questa cartella e aggiornare il percorso in `cover.tex`:
```latex
\includegraphics[width=4cm]{frontespizio/logo.pdf}
```
